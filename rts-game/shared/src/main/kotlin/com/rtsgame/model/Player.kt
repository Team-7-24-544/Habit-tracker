package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
data class Player(
    val id: String,
    val name: String,
    var memory: Int = 100,
    val deck: Deck = Deck.createStarterDeck(),
    val hand: MutableList<Card> = mutableListOf(),
    val maxHandSize: Int = 5,
    var isReady: Boolean = false
) {
    fun drawCard() {
        if (hand.size < maxHandSize) {
            val availableCards = deck.cards.filter { card ->
                !hand.contains(card)
            }
            if (availableCards.isNotEmpty()) {
                hand.add(availableCards.random())
            }
        }
    }
    
    fun playCard(cardId: String): Card? {
        val card = hand.find { it.id == cardId }
        if (card != null && memory >= card.memoryCost) {
            hand.remove(card)
            memory -= card.memoryCost
            return card
        }
        return null
    }
    
    fun canPlayCard(cardId: String): Boolean {
        val card = hand.find { it.id == cardId }
        return card != null && memory >= card.memoryCost
    }
    
    fun addMemory(amount: Int) {
        memory += amount
    }
}
