package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
data class Instance(
    val id: String,
    val ownerId: String,
    val position: Position,
    var health: Int,
    val maxHealth: Int = 1000,
    var memory: Int = 100,
    val maxMemory: Int = 500,
    var isAlive: Boolean = true
) {
    fun takeDamage(damage: Int): Int {
        health -= damage
        if (health <= 0) {
            health = 0
            isAlive = false
        }
        return damage
    }
    
    fun addMemory(amount: Int) {
        memory = minOf(maxMemory, memory + amount)
    }
    
    fun spendMemory(amount: Int): Boolean {
        if (memory >= amount) {
            memory -= amount
            return true
        }
        return false
    }
    
    fun canAfford(cost: Int): Boolean = memory >= cost
}
