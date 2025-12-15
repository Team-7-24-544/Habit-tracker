package com.rtsgame.client

import com.badlogic.gdx.Game
import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.g2d.BitmapFont
import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.rtsgame.client.network.NetworkClient
import com.rtsgame.client.screen.MenuScreen

class RTSGame : Game() {
    lateinit var batch: SpriteBatch
    lateinit var font: BitmapFont
    lateinit var networkClient: NetworkClient
    
    override fun create() {
        batch = SpriteBatch()
        font = BitmapFont() // Default font
        font.data.setScale(1.5f)
        
        networkClient = NetworkClient()
        
        setScreen(MenuScreen(this))
    }
    
    override fun dispose() {
        batch.dispose()
        font.dispose()
        networkClient.disconnect()
    }
}
