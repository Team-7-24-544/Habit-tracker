package com.rtsgame.client.screen

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.Screen
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.GL20
import com.badlogic.gdx.graphics.glutils.ShapeRenderer
import com.rtsgame.client.RTSGame
import kotlinx.coroutines.runBlocking
import java.util.*

class MenuScreen(private val game: RTSGame) : Screen {
    private val shapeRenderer = ShapeRenderer()
    private var sessionId: String? = null
    private var playerId: String = UUID.randomUUID().toString()
    private var isConnecting = false
    
    override fun show() {}
    
    override fun render(delta: Float) {
        Gdx.gl.glClearColor(0.1f, 0.1f, 0.15f, 1f)
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)
        
        game.batch.begin()
        
        game.font.color = Color.WHITE
        game.font.draw(game.batch, "RTS Multiplayer Game", 100f, 600f)
        game.font.draw(game.batch, "Press SPACE to Start Game", 100f, 500f)
        
        if (isConnecting) {
            game.font.draw(game.batch, "Connecting to server...", 100f, 400f)
        }
        
        sessionId?.let {
            game.font.draw(game.batch, "Session ID: $it", 100f, 350f)
            game.font.draw(game.batch, "Waiting for opponent...", 100f, 300f)
        }
        
        game.batch.end()
        
        // Handle input
        if (Gdx.input.isKeyJustPressed(com.badlogic.gdx.Input.Keys.SPACE) && !isConnecting) {
            isConnecting = true
            connectToServer()
        }
    }
    
    private fun connectToServer() {
        runBlocking {
            try {
                // Create session
                val sid = game.networkClient.createSession("localhost:8080")
                if (sid != null) {
                    sessionId = sid
                    
                    // Connect to session
                    game.networkClient.connect("localhost:8080", sid)
                    
                    // Send join event
                    game.networkClient.sendEvent(
                        com.rtsgame.event.GameEvent.JoinGame(
                            playerId = playerId,
                            playerName = "Player_${playerId.take(8)}"
                        )
                    )
                    
                    // Transition to game screen
                    Gdx.app.postRunnable {
                        game.setScreen(GameScreen(game, playerId, sid))
                    }
                } else {
                    isConnecting = false
                }
            } catch (e: Exception) {
                e.printStackTrace()
                isConnecting = false
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
