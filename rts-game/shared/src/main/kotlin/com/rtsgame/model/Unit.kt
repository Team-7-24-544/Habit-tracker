package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
data class Unit(
    val id: String,
    val type: UnitType,
    val ownerId: String,
    var position: Position,
    var health: Int,
    val maxHealth: Int,
    var attack: Int,
    var defense: Int,
    var speed: Int,
    var actionPoints: Int = 0,
    val maxActionPoints: Int = 100,
    var isAlive: Boolean = true,
    val targetPosition: Position? = null,
    val targetUnitId: String? = null
) {
    fun takeDamage(damage: Int): Int {
        val actualDamage = maxOf(0, damage - defense)
        health -= actualDamage
        if (health <= 0) {
            health = 0
            isAlive = false
        }
        return actualDamage
    }
    
    fun heal(amount: Int) {
        health = minOf(maxHealth, health + amount)
    }
    
    fun canAct(): Boolean = isAlive && actionPoints >= maxActionPoints
}
