package com.rtsgame.server.routing

import com.rtsgame.event.GameEvent
import com.rtsgame.server.service.GameService
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import kotlinx.serialization.json.Json

fun Application.configureRouting(gameService: GameService) {
    routing {
        get("/") {
            call.respondText("RTS Game Server is running")
        }
        
        get("/api/session/create") {
            val sessionId = gameService.createSession()
            call.respond(mapOf("sessionId" to sessionId))
        }
        
        webSocket("/ws/{sessionId}") {
            val sessionId = call.parameters["sessionId"] ?: return@webSocket
            
            try {
                for (frame in incoming) {
                    if (frame is Frame.Text) {
                        val text = frame.readText()
                        try {
                            val event = Json.decodeFromString<GameEvent>(text)
                            gameService.handleEvent(sessionId, event, this)
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
