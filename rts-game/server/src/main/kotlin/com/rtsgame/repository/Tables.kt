package com.rtsgame.repository

import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant

object GameSessions : Table("game_sessions") {
    val id = varchar("id", 50)
    val status = varchar("status", 20)
    val winnerId = varchar("winner_id", 50).nullable()
    val createdAt = timestamp("created_at").default(Clock.System.now())
    val finishedAt = timestamp("finished_at").nullable()
    val gameData = text("game_data")
    
    override val primaryKey = PrimaryKey(id)
}

object GamePlayers : Table("game_players") {
    val id = varchar("id", 50)
    val sessionId = varchar("session_id", 50)
    val name = varchar("name", 100)
    val memory = integer("memory")
    val isWinner = bool("is_winner").default(false)
    
    override val primaryKey = PrimaryKey(id)
}

object GameUnits : Table("game_units") {
    val id = varchar("id", 50)
    val sessionId = varchar("session_id", 50)
    val ownerId = varchar("owner_id", 50)
    val unitType = varchar("unit_type", 50)
    val positionX = integer("position_x")
    val positionY = integer("position_y")
    val health = integer("health")
    val isAlive = bool("is_alive").default(true)
    val createdAt = timestamp("created_at").default(Clock.System.now())
    
    override val primaryKey = PrimaryKey(id)
}
