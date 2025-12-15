package com.rtsgame.model

import kotlinx.serialization.Serializable

@Serializable
enum class UnitType(
    val displayName: String,
    val memoryCost: Int,
    val description: String,
    val category: UnitCategory
) {
    // Basic Processes
    ALLOCATOR("Allocator", 50, "Captures memory nodes, produces Memory passively", UnitCategory.BASIC),
    GARBAGE_COLLECTOR("Garbage Collector", 40, "Cleans garbage and returns memory", UnitCategory.BASIC),
    BASIC_PROCESS("Basic Process", 30, "Cheap infantry warrior", UnitCategory.BASIC),
    
    // OOP Units
    INHERITANCE_DRONE("Inheritance Drone", 80, "Inherits best parameters from fallen allies", UnitCategory.OOP),
    POLYMORPH_WARRIOR("Polymorph Warrior", 70, "Changes attack type based on target", UnitCategory.OOP),
    ENCAPSULATION_SHIELD("Encapsulation Shield", 60, "Creates invisible protection", UnitCategory.OOP),
    ABSTRACTION_AGENT("Abstraction Agent", 65, "Hides allies from enemies", UnitCategory.OOP),
    
    // Reflection & Metaprogramming
    REFLECTION_SPY("Reflection Spy", 55, "Scans enemy units and reveals stats", UnitCategory.REFLECTION),
    CODE_INJECTOR("Code Injector", 90, "Injects bugs into enemy factories", UnitCategory.REFLECTION),
    DYNAMIC_DISPATCHER("Dynamic Dispatcher", 75, "Increases CPS of nearby allies", UnitCategory.REFLECTION),
    
    // Asynchrony & Parallelism
    COROUTINE_ARCHER("Coroutine Archer", 65, "Shoots async arrows that pierce defense", UnitCategory.ASYNC),
    PROMISE_KNIGHT("Promise Knight", 70, "Delayed damage promise on death", UnitCategory.ASYNC),
    DEADLOCK_TRAP("Deadlock Trap", 100, "Immobilizes multiple attacking units", UnitCategory.ASYNC),
    
    // Functional Programming
    LAMBDA_SNIPER("Lambda Sniper", 85, "One-shot lethal attack, pure function", UnitCategory.FUNCTIONAL),
    RECURSIVE_BOMB("Recursive Bomb", 80, "Explodes into smaller bombs recursively", UnitCategory.FUNCTIONAL),
    HIGHER_ORDER_COMMANDER("Higher-Order Commander", 95, "Enhances other units as functions", UnitCategory.FUNCTIONAL),
    
    // Network & Communication
    API_GATEWAY("API Gateway", 60, "Extends ally action radius", UnitCategory.NETWORK),
    WEBSOCKET_SCOUT("WebSocket Scout", 50, "Continuously reports enemy positions", UnitCategory.NETWORK),
    RESTFUL_HEALER("RESTful Healer", 70, "CRUD operations for healing and buffs", UnitCategory.NETWORK),
    
    // Storage
    CACHE_RUNNER("Cache Runner", 45, "Fast unit with low HP, captures cache nodes", UnitCategory.STORAGE),
    INDEXER("Indexer", 55, "Marks targets, increases ally damage", UnitCategory.STORAGE),
    TRANSACTION_GUARD("Transaction Guard", 75, "Rolls back node status on death", UnitCategory.STORAGE);
}

@Serializable
enum class UnitCategory {
    BASIC, OOP, REFLECTION, ASYNC, FUNCTIONAL, NETWORK, STORAGE
}
