package com.rtsgame.client.network

import com.rtsgame.event.GameEvent
import com.rtsgame.event.ServerEvent
import io.ktor.client.*
import io.ktor.client.engine.cio.*
import io.ktor.client.plugins.websocket.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.websocket.*
import kotlinx.coroutines.*
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.util.concurrent.ConcurrentLinkedQueue

class NetworkClient {
    private val client = HttpClient(CIO) {
        install(WebSockets)
    }
    
    private var webSocketSession: DefaultClientWebSocketSession? = null
    private val eventQueue = ConcurrentLinkedQueue<ServerEvent>()
    private val coroutineScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    
    var isConnected = false
        private set
    
    suspend fun createSession(serverUrl: String = "localhost:8080"): String? {
        return try {
            val response = client.get("http://$serverUrl/api/session/create")
            val json = response.bodyAsText()
            Json.decodeFromString<Map<String, String>>(json)["sessionId"]
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
    
    suspend fun connect(serverUrl: String, sessionId: String) {
        try {
            webSocketSession = client.webSocketSession(
                method = HttpMethod.Get,
                host = serverUrl.split(":")[0],
                port = serverUrl.split(":")[1].toInt(),
                path = "/ws/$sessionId"
            )
            
            isConnected = true
            
            // Start listening for messages
            coroutineScope.launch {
                webSocketSession?.let { session ->
                    try {
                        for (frame in session.incoming) {
                            if (frame is Frame.Text) {
                                val text = frame.readText()
                                try {
                                    val event = Json.decodeFromString<ServerEvent>(text)
                                    eventQueue.offer(event)
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                }
                            }
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                        isConnected = false
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            isConnected = false
        }
    }
    
    fun pollEvent(): ServerEvent? = eventQueue.poll()
    
    suspend fun sendEvent(event: GameEvent) {
        webSocketSession?.let { session ->
            try {
                val message = Json.encodeToString(event)
                session.send(Frame.Text(message))
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
    
    fun disconnect() {
        coroutineScope.cancel()
        runBlocking {
            webSocketSession?.close()
        }
        client.close()
        isConnected = false
    }
}
