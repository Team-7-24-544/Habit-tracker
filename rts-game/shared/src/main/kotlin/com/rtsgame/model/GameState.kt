package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
enum class GameStatus {
    WAITING_FOR_PLAYERS,
    READY,
    IN_PROGRESS,
    FINISHED
}

@Serializable
data class GameState(
    val sessionId: String,
    val boardWidth: Int = 30,
    val boardHeight: Int = 20,
    val players: MutableMap<String, Player> = mutableMapOf(),
    val instances: MutableMap<String, Instance> = mutableMapOf(),
    val factories: MutableMap<String, Factory> = mutableMapOf(),
    val units: MutableMap<String, Unit> = mutableMapOf(),
    val memoryNodes: MutableMap<String, MemoryNode> = mutableMapOf(),
    var status: GameStatus = GameStatus.WAITING_FOR_PLAYERS,
    var currentTick: Long = 0,
    var winnerId: String? = null
) {
    fun addPlayer(player: Player) {
        if (players.size < 2) {
            players[player.id] = player
            
            // Create instance for player
            val instancePos = if (players.size == 1) {
                Position(2, boardHeight / 2)
            } else {
                Position(boardWidth - 3, boardHeight / 2)
            }
            
            val instance = Instance(
                id = "instance_${player.id}",
                ownerId = player.id,
                position = instancePos,
                health = 1000
            )
            instances[instance.id] = instance
            
            // Create starting factory
            val factoryPos = if (players.size == 1) {
                Position(5, boardHeight / 2)
            } else {
                Position(boardWidth - 6, boardHeight / 2)
            }
            
            val factory = Factory(
                id = "factory_${player.id}_1",
                ownerId = player.id,
                position = factoryPos,
                health = 500
            )
            factories[factory.id] = factory
            
            if (players.size == 2) {
                status = GameStatus.READY
            }
        }
    }
    
    fun isGameOver(): Boolean {
        val aliveInstances = instances.values.filter { it.isAlive }
        return aliveInstances.size <= 1
    }
    
    fun getWinner(): String? {
        val aliveInstances = instances.values.filter { it.isAlive }
        return if (aliveInstances.size == 1) aliveInstances.first().ownerId else null
    }
}
