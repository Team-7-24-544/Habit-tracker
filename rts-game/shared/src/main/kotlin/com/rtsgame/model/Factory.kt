package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
data class Factory(
    val id: String,
    val ownerId: String,
    val position: Position,
    var health: Int,
    val maxHealth: Int = 500,
    var productionSpeed: Int = 100,
    var level: Int = 1,
    val availableUnits: MutableList<UnitType> = mutableListOf(
        UnitType.BASIC_PROCESS,
        UnitType.ALLOCATOR,
        UnitType.GARBAGE_COLLECTOR
    ),
    var isProducing: Boolean = false,
    var currentProduction: UnitType? = null,
    var productionProgress: Int = 0
) {
    fun canProduce(unitType: UnitType): Boolean {
        return availableUnits.contains(unitType) && !isProducing
    }
    
    fun startProduction(unitType: UnitType) {
        if (canProduce(unitType)) {
            isProducing = true
            currentProduction = unitType
            productionProgress = 0
        }
    }
    
    fun updateProduction(): Boolean {
        if (isProducing && currentProduction != null) {
            productionProgress += productionSpeed
            if (productionProgress >= 1000) {
                isProducing = false
                productionProgress = 0
                return true // Production complete
            }
        }
        return false
    }
    
    fun upgrade() {
        level++
        productionSpeed += 20
        maxHealth + 200
        
        // Unlock more units at higher levels
        when (level) {
            2 -> availableUnits.addAll(listOf(UnitType.POLYMORPH_WARRIOR, UnitType.CACHE_RUNNER))
            3 -> availableUnits.addAll(listOf(UnitType.COROUTINE_ARCHER, UnitType.REFLECTION_SPY))
            4 -> availableUnits.addAll(listOf(UnitType.LAMBDA_SNIPER, UnitType.API_GATEWAY))
        }
    }
}
