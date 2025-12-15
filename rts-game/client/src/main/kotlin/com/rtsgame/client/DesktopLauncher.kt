package com.rtsgame.client

import com.badlogic.gdx.backends.lwjgl3.Lwjgl3Application
import com.badlogic.gdx.backends.lwjgl3.Lwjgl3ApplicationConfiguration

fun main() {
    val config = Lwjgl3ApplicationConfiguration().apply {
        setTitle("RTS Multiplayer Game")
        setWindowedMode(1280, 720)
        useVsync(true)
        setForegroundFPS(60)
    }
    
    Lwjgl3Application(RTSGame(), config)
}
