package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
enum class CardType {
    SPAWN_UNIT,
    FACTORY_UPGRADE,
    DIRECT_DAMAGE,
    HEAL,
    BOOST,
    SPECIAL_ABILITY
}

@Serializable
data class Card(
    val id: String,
    val name: String,
    val type: CardType,
    val memoryCost: Int,
    val description: String,
    val unitType: UnitType? = null,
    val effect: CardEffect? = null
)

@Serializable
data class CardEffect(
    val damage: Int = 0,
    val heal: Int = 0,
    val boostAttack: Int = 0,
    val boostDefense: Int = 0,
    val duration: Int = 0
)

@Serializable
data class Deck(
    val cards: List<Card>
) {
    companion object {
        fun createStarterDeck(): Deck {
            return Deck(
                listOf(
                    // Basic unit spawns
                    Card("card_1", "Deploy Basic Process", CardType.SPAWN_UNIT, 30, 
                        "Spawn a Basic Process unit", UnitType.BASIC_PROCESS),
                    Card("card_2", "Deploy Allocator", CardType.SPAWN_UNIT, 50,
                        "Spawn an Allocator to capture memory", UnitType.ALLOCATOR),
                    Card("card_3", "Deploy Garbage Collector", CardType.SPAWN_UNIT, 40,
                        "Spawn a Garbage Collector", UnitType.GARBAGE_COLLECTOR),
                    
                    // OOP units
                    Card("card_4", "Deploy Polymorph Warrior", CardType.SPAWN_UNIT, 70,
                        "Adaptive combat unit", UnitType.POLYMORPH_WARRIOR),
                    Card("card_5", "Deploy Encapsulation Shield", CardType.SPAWN_UNIT, 60,
                        "Defensive support unit", UnitType.ENCAPSULATION_SHIELD),
                    
                    // Async units
                    Card("card_6", "Deploy Coroutine Archer", CardType.SPAWN_UNIT, 65,
                        "Ranged async attacker", UnitType.COROUTINE_ARCHER),
                    
                    // Special abilities
                    Card("card_7", "Memory Boost", CardType.BOOST, 20,
                        "Increase memory production", effect = CardEffect(boostAttack = 5, duration = 10)),
                    Card("card_8", "Quick Heal", CardType.HEAL, 30,
                        "Heal target unit", effect = CardEffect(heal = 50)),
                    Card("card_9", "Direct Strike", CardType.DIRECT_DAMAGE, 40,
                        "Deal direct damage", effect = CardEffect(damage = 80)),
                    Card("card_10", "Upgrade Factory", CardType.FACTORY_UPGRADE, 100,
                        "Upgrade factory level")
                )
            )
        }
    }
}
