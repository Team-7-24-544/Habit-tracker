package com.rtsgame.server.service

import com.rtsgame.event.GameEvent
import com.rtsgame.event.ServerEvent
import com.rtsgame.model.*
import com.rtsgame.repository.GameRepository
import io.ktor.websocket.*
import kotlinx.coroutines.*
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.util.*
import java.util.concurrent.ConcurrentHashMap
import com.rtsgame.model.Unit as GameUnit

class GameService {
    private val sessions = ConcurrentHashMap<String, GameSession>()
    private val repository = GameRepository()
    private val gameLoop = CoroutineScope(Dispatchers.Default + SupervisorJob())
    
    inner class GameSession(val sessionId: String) {
        val gameState = GameState(sessionId)
        val connections = ConcurrentHashMap<String, DefaultWebSocketSession>()
        var isRunning = false
        
        fun addConnection(playerId: String, session: DefaultWebSocketSession) {
            connections[playerId] = session
        }
        
        suspend fun broadcast(event: ServerEvent) {
            val message = Json.encodeToString(event)
            connections.values.forEach { connection ->
                try {
                    connection.send(Frame.Text(message))
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
        
        suspend fun startGameLoop() {
            if (isRunning) return
            isRunning = true
            gameState.status = GameStatus.IN_PROGRESS
            repository.updateGameSession(gameState)
            
            broadcast(ServerEvent.GameStarted(sessionId))
            
            gameLoop.launch {
                while (isRunning && gameState.status == GameStatus.IN_PROGRESS) {
                    delay(100) // 10 ticks per second
                    
                    updateGame()
                    
                    if (gameState.isGameOver()) {
                        endGame()
                        break
                    }
                }
            }
        }
        
        private suspend fun updateGame() {
            gameState.currentTick++
            
            // Update units (action points, movement)
            gameState.units.values.forEach { unit ->
                if (unit.isAlive) {
                    unit.actionPoints = minOf(unit.maxActionPoints, unit.actionPoints + 10)
                }
            }
            
            // Update factories (production)
            gameState.factories.values.forEach { factory ->
                if (factory.updateProduction()) {
                    factory.currentProduction?.let { unitType ->
                        spawnUnit(factory, unitType)
                    }
                }
            }
            
            // Produce memory from captured nodes
            gameState.memoryNodes.values.filter { it.isCaptured() }.forEach { node ->
                node.ownerId?.let { playerId ->
                    gameState.players[playerId]?.addMemory(node.memoryProduction / 10)
                }
            }
            
            // Periodic state broadcast (every 10 ticks = 1 second)
            if (gameState.currentTick % 10 == 0L) {
                broadcast(ServerEvent.GameStateUpdate(gameState))
            }
        }
        
        private suspend fun spawnUnit(factory: Factory, unitType: UnitType) {
            val unitStats = getUnitStats(unitType)
            val unit = GameUnit(
                id = UUID.randomUUID().toString(),
                type = unitType,
                ownerId = factory.ownerId,
                position = factory.position.copy(),
                health = unitStats.health,
                maxHealth = unitStats.health,
                attack = unitStats.attack,
                defense = unitStats.defense,
                speed = unitStats.speed
            )
            
            gameState.units[unit.id] = unit
            repository.saveUnit(unit, sessionId)
            broadcast(ServerEvent.UnitSpawned(unit, factory.id))
        }
        
        private suspend fun endGame() {
            gameState.status = GameStatus.FINISHED
            gameState.winnerId = gameState.getWinner()
            isRunning = false
            
            repository.updateGameSession(gameState)
            gameState.winnerId?.let {
                broadcast(ServerEvent.GameEnded(it, "Instance destroyed"))
            }
        }
    }
    
    fun createSession(): String {
        val sessionId = UUID.randomUUID().toString()
        val session = GameSession(sessionId)
        
        // Initialize memory nodes
        for (i in 0 until 10) {
            val node = MemoryNode(
                id = "node_$i",
                position = Position(
                    (5..25).random(),
                    (3..17).random()
                ),
                type = MemoryNodeType.values().random()
            )
            session.gameState.memoryNodes[node.id] = node
        }
        
        sessions[sessionId] = session
        
        return sessionId
    }
    
    fun getSession(sessionId: String): GameSession? = sessions[sessionId]
    
    suspend fun handleEvent(sessionId: String, event: GameEvent, connection: DefaultWebSocketSession) {
        val session = sessions[sessionId] ?: return
        
        when (event) {
            is GameEvent.JoinGame -> {
                val player = Player(
                    id = event.playerId,
                    name = event.playerName
                )
                session.gameState.addPlayer(player)
                session.addConnection(player.id, connection)
                repository.savePlayer(player, sessionId)
                
                // Draw initial hand
                repeat(5) { player.drawCard() }
                
                if (session.gameState.status == GameStatus.READY) {
                    repository.saveGameSession(session.gameState)
                }
                
                session.broadcast(ServerEvent.GameStateUpdate(session.gameState))
            }
            
            is GameEvent.PlayerReady -> {
                session.gameState.players[event.playerId]?.isReady = true
                val allReady = session.gameState.players.values.all { it.isReady }
                
                if (allReady && session.gameState.status == GameStatus.READY) {
                    session.startGameLoop()
                }
            }
            
            is GameEvent.PlayCard -> {
                handlePlayCard(session, event)
            }
            
            is GameEvent.MoveUnit -> {
                handleMoveUnit(session, event)
            }
            
            is GameEvent.AttackTarget -> {
                handleAttack(session, event)
            }
            
            is GameEvent.CaptureNode -> {
                handleCapture(session, event)
            }
        }
    }
    
    private suspend fun handlePlayCard(session: GameSession, event: GameEvent.PlayCard) {
        val player = session.gameState.players[event.playerId] ?: return
        val card = player.playCard(event.cardId) ?: return
        
        when (card.type) {
            CardType.SPAWN_UNIT -> {
                card.unitType?.let { unitType ->
                    val factory = session.gameState.factories.values
                        .find { it.ownerId == event.playerId && !it.isProducing }
                    
                    factory?.startProduction(unitType)
                }
            }
            
            CardType.FACTORY_UPGRADE -> {
                event.targetId?.let { factoryId ->
                    session.gameState.factories[factoryId]?.upgrade()
                }
            }
            
            CardType.DIRECT_DAMAGE -> {
                event.targetId?.let { targetId ->
                    session.gameState.units[targetId]?.let { target ->
                        val damage = card.effect?.damage ?: 0
                        target.takeDamage(damage)
                        session.broadcast(ServerEvent.UnitAttacked(event.playerId, targetId, damage))
                        
                        if (!target.isAlive) {
                            session.broadcast(ServerEvent.UnitDied(targetId))
                        }
                    }
                }
            }
            
            CardType.HEAL -> {
                event.targetId?.let { targetId ->
                    session.gameState.units[targetId]?.let { target ->
                        if (target.ownerId == event.playerId) {
                            val heal = card.effect?.heal ?: 0
                            target.heal(heal)
                        }
                    }
                }
            }
            
            else -> {}
        }
        
        // Draw a new card
        player.drawCard()
        session.broadcast(ServerEvent.GameStateUpdate(session.gameState))
    }
    
    private suspend fun handleMoveUnit(session: GameSession, event: GameEvent.MoveUnit) {
        val unit = session.gameState.units[event.unitId] ?: return
        if (unit.ownerId != event.playerId || !unit.canAct()) return
        
        // Simple movement - just set position (real game would path-find)
        unit.position = event.targetPosition
        unit.actionPoints = 0
        
        repository.updateUnit(unit)
        session.broadcast(ServerEvent.UnitMoved(event.unitId, event.targetPosition))
    }
    
    private suspend fun handleAttack(session: GameSession, event: GameEvent.AttackTarget) {
        val attacker = session.gameState.units[event.unitId] ?: return
        val target = session.gameState.units[event.targetId] ?: return
        
        if (attacker.ownerId != event.playerId || !attacker.canAct()) return
        if (attacker.position.distanceTo(target.position) > 2.0) return
        
        val damage = attacker.attack
        target.takeDamage(damage)
        attacker.actionPoints = 0
        
        session.broadcast(ServerEvent.UnitAttacked(event.unitId, event.targetId, damage))
        
        if (!target.isAlive) {
            repository.updateUnit(target)
            session.broadcast(ServerEvent.UnitDied(event.targetId))
        }
    }
    
    private suspend fun handleCapture(session: GameSession, event: GameEvent.CaptureNode) {
        val unit = session.gameState.units[event.unitId] ?: return
        val node = session.gameState.memoryNodes[event.nodeId] ?: return
        
        if (unit.ownerId != event.playerId) return
        if (!unit.position.isAdjacent(node.position)) return
        
        if (node.capture(event.playerId, 10)) {
            session.broadcast(ServerEvent.NodeCaptured(event.nodeId, event.playerId))
        }
    }
    
    private fun getUnitStats(unitType: UnitType): UnitStats {
        return when (unitType.category) {
            UnitCategory.BASIC -> UnitStats(100, 20, 10, 5)
            UnitCategory.OOP -> UnitStats(120, 25, 15, 4)
            UnitCategory.REFLECTION -> UnitStats(80, 15, 5, 6)
            UnitCategory.ASYNC -> UnitStats(90, 30, 8, 7)
            UnitCategory.FUNCTIONAL -> UnitStats(70, 40, 5, 5)
            UnitCategory.NETWORK -> UnitStats(85, 18, 12, 6)
            UnitCategory.STORAGE -> UnitStats(110, 22, 18, 4)
        }
    }
    
    data class UnitStats(val health: Int, val attack: Int, val defense: Int, val speed: Int)
}
