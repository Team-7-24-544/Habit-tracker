package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
enum class MemoryNodeType {
    RAM, CACHE, HEAP, STACK
}

@Serializable
data class MemoryNode(
    val id: String,
    val position: Position,
    val type: MemoryNodeType,
    var ownerId: String? = null,
    val memoryProduction: Int = when(type) {
        MemoryNodeType.RAM -> 10
        MemoryNodeType.CACHE -> 15
        MemoryNodeType.HEAP -> 8
        MemoryNodeType.STACK -> 5
    },
    var captureProgress: Int = 0,
    val captureRequired: Int = 100
) {
    fun isCaptured(): Boolean = ownerId != null
    
    fun isNeutral(): Boolean = ownerId == null
    
    fun capture(playerId: String, amount: Int): Boolean {
        if (ownerId != playerId) {
            captureProgress += amount
            if (captureProgress >= captureRequired) {
                ownerId = playerId
                captureProgress = 0
                return true
            }
        }
        return false
    }
    
    fun resetCapture() {
        captureProgress = 0
    }
}
