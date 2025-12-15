package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
data class Position(
    val x: Int,
    val y: Int
) {
    fun distanceTo(other: Position): Double {
        val dx = (x - other.x).toDouble()
        val dy = (y - other.y).toDouble()
        return kotlin.math.sqrt(dx * dx + dy * dy)
    }
    
    fun isAdjacent(other: Position): Boolean {
        return kotlin.math.abs(x - other.x) <= 1 && kotlin.math.abs(y - other.y) <= 1
    }
}
