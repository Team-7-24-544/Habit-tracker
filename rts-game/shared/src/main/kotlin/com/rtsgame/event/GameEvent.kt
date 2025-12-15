package com.rtsgame.event

import com.rtsgame.model.*
import kotlinx.serialization.Serializable
import com.rtsgame.model.Unit as GameUnit

@Serializable
sealed class GameEvent {
    abstract val playerId: String
    
    @Serializable
    data class JoinGame(
        override val playerId: String,
        val playerName: String
    ) : GameEvent()
    
    @Serializable
    data class PlayerReady(
        override val playerId: String
    ) : GameEvent()
    
    @Serializable
    data class PlayCard(
        override val playerId: String,
        val cardId: String,
        val targetPosition: Position? = null,
        val targetId: String? = null
    ) : GameEvent()
    
    @Serializable
    data class MoveUnit(
        override val playerId: String,
        val unitId: String,
        val targetPosition: Position
    ) : GameEvent()
    
    @Serializable
    data class AttackTarget(
        override val playerId: String,
        val unitId: String,
        val targetId: String
    ) : GameEvent()
    
    @Serializable
    data class CaptureNode(
        override val playerId: String,
        val unitId: String,
        val nodeId: String
    ) : GameEvent()
}

@Serializable
sealed class ServerEvent {
    @Serializable
    data class GameStateUpdate(
        val gameState: GameState
    ) : ServerEvent()
    
    @Serializable
    data class UnitSpawned(
        val unit: GameUnit,
        val factoryId: String
    ) : ServerEvent()
    
    @Serializable
    data class UnitMoved(
        val unitId: String,
        val newPosition: Position
    ) : ServerEvent()
    
    @Serializable
    data class UnitAttacked(
        val attackerId: String,
        val targetId: String,
        val damage: Int
    ) : ServerEvent()
    
    @Serializable
    data class UnitDied(
        val unitId: String
    ) : ServerEvent()
    
    @Serializable
    data class NodeCaptured(
        val nodeId: String,
        val playerId: String
    ) : ServerEvent()
    
    @Serializable
    data class MemoryProduced(
        val playerId: String,
        val amount: Int
    ) : ServerEvent()
    
    @Serializable
    data class GameStarted(
        val sessionId: String
    ) : ServerEvent()
    
    @Serializable
    data class GameEnded(
        val winnerId: String,
        val reason: String
    ) : ServerEvent()
    
    @Serializable
    data class ErrorEvent(
        val message: String
    ) : ServerEvent()
}
