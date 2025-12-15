package com.rtsgame.client.screen

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.Input
import com.badlogic.gdx.Screen
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.GL20
import com.badlogic.gdx.graphics.glutils.ShapeRenderer
import com.badlogic.gdx.math.Vector2
import com.rtsgame.client.RTSGame
import com.rtsgame.event.GameEvent
import com.rtsgame.event.ServerEvent
import com.rtsgame.model.*
import kotlinx.coroutines.runBlocking
import com.rtsgame.model.Unit as GameUnit

class GameScreen(
    private val game: RTSGame,
    private val playerId: String,
    private val sessionId: String
) : Screen {
    
    private val shapeRenderer = ShapeRenderer()
    private var gameState: GameState? = null
    private val cellSize = 25f
    private val offsetX = 50f
    private val offsetY = 50f
    
    private var selectedUnitId: String? = null
    private var selectedCardId: String? = null
    private var isReady = false
    
    override fun show() {}
    
    override fun render(delta: Float) {
        // Process network events
        processNetworkEvents()
        
        // Clear screen
        Gdx.gl.glClearColor(0.05f, 0.05f, 0.1f, 1f)
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)
        
        gameState?.let { state ->
            renderGame(state)
        }
        
        // Handle input
        handleInput()
    }
    
    private fun processNetworkEvents() {
        var event = game.networkClient.pollEvent()
        while (event != null) {
            when (event) {
                is ServerEvent.GameStateUpdate -> {
                    gameState = event.gameState
                }
                is ServerEvent.GameStarted -> {
                    println("Game started!")
                }
                is ServerEvent.GameEnded -> {
                    println("Game ended! Winner: ${event.winnerId}")
                }
                is ServerEvent.UnitSpawned -> {
                    println("Unit spawned: ${event.unit.type}")
                }
                else -> {}
            }
            event = game.networkClient.pollEvent()
        }
    }
    
    private fun renderGame(state: GameState) {
        // Render board grid
        shapeRenderer.begin(ShapeRenderer.ShapeType.Line)
        shapeRenderer.color = Color.GRAY
        
        for (x in 0..state.boardWidth) {
            shapeRenderer.line(
                offsetX + x * cellSize, offsetY,
                offsetX + x * cellSize, offsetY + state.boardHeight * cellSize
            )
        }
        for (y in 0..state.boardHeight) {
            shapeRenderer.line(
                offsetX, offsetY + y * cellSize,
                offsetX + state.boardWidth * cellSize, offsetY + y * cellSize
            )
        }
        shapeRenderer.end()
        
        // Render game objects
        shapeRenderer.begin(ShapeRenderer.ShapeType.Filled)
        
        // Render instances
        state.instances.values.forEach { instance ->
            shapeRenderer.color = if (instance.ownerId == playerId) Color.GREEN else Color.RED
            shapeRenderer.rect(
                offsetX + instance.position.x * cellSize,
                offsetY + instance.position.y * cellSize,
                cellSize * 2,
                cellSize * 2
            )
        }
        
        // Render factories
        state.factories.values.forEach { factory ->
            shapeRenderer.color = if (factory.ownerId == playerId) Color.CYAN else Color.ORANGE
            shapeRenderer.rect(
                offsetX + factory.position.x * cellSize,
                offsetY + factory.position.y * cellSize,
                cellSize * 1.5f,
                cellSize * 1.5f
            )
        }
        
        // Render memory nodes
        state.memoryNodes.values.forEach { node ->
            shapeRenderer.color = when {
                node.ownerId == playerId -> Color.BLUE
                node.ownerId != null -> Color.PURPLE
                else -> Color.YELLOW
            }
            shapeRenderer.circle(
                offsetX + node.position.x * cellSize + cellSize / 2,
                offsetY + node.position.y * cellSize + cellSize / 2,
                cellSize / 2
            )
        }
        
        // Render units
        state.units.values.filter { it.isAlive }.forEach { unit ->
            shapeRenderer.color = if (unit.ownerId == playerId) Color.LIME else Color.PINK
            if (unit.id == selectedUnitId) {
                shapeRenderer.color = Color.WHITE
            }
            shapeRenderer.circle(
                offsetX + unit.position.x * cellSize + cellSize / 2,
                offsetY + unit.position.y * cellSize + cellSize / 2,
                cellSize / 3
            )
        }
        
        shapeRenderer.end()
        
        // Render UI
        game.batch.begin()
        
        val player = state.players[playerId]
        player?.let {
            game.font.color = Color.WHITE
            game.font.draw(game.batch, "Memory: ${it.memory}", 10f, Gdx.graphics.height - 10f)
            
            // Draw hand
            var cardY = Gdx.graphics.height - 50f
            game.font.draw(game.batch, "Hand:", 10f, cardY)
            cardY -= 30f
            
            it.hand.forEachIndexed { index, card ->
                val color = if (card.id == selectedCardId) Color.YELLOW else Color.LIGHT_GRAY
                game.font.color = color
                game.font.draw(
                    game.batch,
                    "${index + 1}. ${card.name} (${card.memoryCost})",
                    10f,
                    cardY
                )
                cardY -= 25f
            }
            
            // Ready status
            if (!isReady && state.status == GameStatus.READY) {
                game.font.color = Color.YELLOW
                game.font.draw(game.batch, "Press R to Ready", 10f, 200f)
            }
            
            // Game status
            game.font.color = Color.CYAN
            game.font.draw(game.batch, "Status: ${state.status}", 10f, 150f)
        }
        
        game.batch.end()
    }
    
    private fun handleInput() {
        val state = gameState ?: return
        val player = state.players[playerId] ?: return
        
        // Ready up
        if (Gdx.input.isKeyJustPressed(Input.Keys.R) && !isReady && state.status == GameStatus.READY) {
            isReady = true
            runBlocking {
                game.networkClient.sendEvent(GameEvent.PlayerReady(playerId))
            }
        }
        
        // Select card (1-5 keys)
        for (i in 1..5) {
            if (Gdx.input.isKeyJustPressed(Input.Keys.NUM_1 + i - 1)) {
                if (player.hand.size >= i) {
                    selectedCardId = player.hand[i - 1].id
                    println("Selected card: ${player.hand[i - 1].name}")
                }
            }
        }
        
        // Mouse click
        if (Gdx.input.isButtonJustPressed(Input.Buttons.LEFT)) {
            val mouseX = Gdx.input.x.toFloat()
            val mouseY = (Gdx.graphics.height - Gdx.input.y).toFloat()
            
            val gridX = ((mouseX - offsetX) / cellSize).toInt()
            val gridY = ((mouseY - offsetY) / cellSize).toInt()
            
            if (gridX in 0 until state.boardWidth && gridY in 0 until state.boardHeight) {
                val clickPos = Position(gridX, gridY)
                
                // Try to select a unit
                val clickedUnit = state.units.values.find {
                    it.isAlive && it.ownerId == playerId &&
                            it.position.x == gridX && it.position.y == gridY
                }
                
                if (clickedUnit != null) {
                    selectedUnitId = clickedUnit.id
                    println("Selected unit: ${clickedUnit.type}")
                } else if (selectedCardId != null) {
                    // Play card at position
                    runBlocking {
                        game.networkClient.sendEvent(
                            GameEvent.PlayCard(
                                playerId = playerId,
                                cardId = selectedCardId!!,
                                targetPosition = clickPos
                            )
                        )
                    }
                    selectedCardId = null
                }
            }
        }
        
        // Right click to move unit or attack
        if (Gdx.input.isButtonJustPressed(Input.Buttons.RIGHT)) {
            selectedUnitId?.let { unitId ->
                val mouseX = Gdx.input.x.toFloat()
                val mouseY = (Gdx.graphics.height - Gdx.input.y).toFloat()
                
                val gridX = ((mouseX - offsetX) / cellSize).toInt()
                val gridY = ((mouseY - offsetY) / cellSize).toInt()
                
                if (gridX in 0 until state.boardWidth && gridY in 0 until state.boardHeight) {
                    val targetPos = Position(gridX, gridY)
                    
                    // Check if there's an enemy unit at target
                    val targetUnit = state.units.values.find {
                        it.isAlive && it.ownerId != playerId &&
                                it.position.x == gridX && it.position.y == gridY
                    }
                    
                    runBlocking {
                        if (targetUnit != null) {
                            // Attack
                            game.networkClient.sendEvent(
                                GameEvent.AttackTarget(playerId, unitId, targetUnit.id)
                            )
                        } else {
                            // Move
                            game.networkClient.sendEvent(
                                GameEvent.MoveUnit(playerId, unitId, targetPos)
                            )
                        }
                    }
                }
            }
        }
    }
    
    override fun resize(width: Int, height: Int) {}
    override fun pause() {}
    override fun resume() {}
    override fun hide() {}
    override fun dispose() {
        shapeRenderer.dispose()
    }
}
