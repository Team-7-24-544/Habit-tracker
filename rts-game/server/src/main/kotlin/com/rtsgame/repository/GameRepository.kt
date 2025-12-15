package com.rtsgame.repository

import com.rtsgame.model.*
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.jetbrains.exposed.sql.*
import com.rtsgame.model.Unit as GameUnit

class GameRepository {
    
    suspend fun saveGameSession(gameState: GameState) = DatabaseFactory.dbQuery {
        GameSessions.insert {
            it[GameSessions.id] = gameState.sessionId
            it[GameSessions.status] = gameState.status.name
            it[GameSessions.winnerId] = gameState.winnerId
            it[GameSessions.gameData] = Json.encodeToString(gameState)
            it[GameSessions.createdAt] = kotlinx.datetime.Clock.System.now()
        }
    }
    
    suspend fun updateGameSession(gameState: GameState) = DatabaseFactory.dbQuery {
        GameSessions.update({ GameSessions.id eq gameState.sessionId }) {
            it[GameSessions.status] = gameState.status.name
            it[GameSessions.winnerId] = gameState.winnerId
            it[GameSessions.gameData] = Json.encodeToString(gameState)
            if (gameState.status == GameStatus.FINISHED) {
                it[GameSessions.finishedAt] = kotlinx.datetime.Clock.System.now()
            }
        }
    }
    
    suspend fun savePlayer(player: Player, sessionId: String) = DatabaseFactory.dbQuery {
        GamePlayers.insert {
            it[GamePlayers.id] = player.id
            it[GamePlayers.sessionId] = sessionId
            it[GamePlayers.name] = player.name
            it[GamePlayers.memory] = player.memory
        }
    }
    
    suspend fun saveUnit(unit: GameUnit, sessionId: String) = DatabaseFactory.dbQuery {
        GameUnits.insert {
            it[GameUnits.id] = unit.id
            it[GameUnits.sessionId] = sessionId
            it[GameUnits.ownerId] = unit.ownerId
            it[GameUnits.unitType] = unit.type.name
            it[GameUnits.positionX] = unit.position.x
            it[GameUnits.positionY] = unit.position.y
            it[GameUnits.health] = unit.health
            it[GameUnits.isAlive] = unit.isAlive
        }
    }
    
    suspend fun updateUnit(unit: GameUnit) = DatabaseFactory.dbQuery {
        GameUnits.update({ GameUnits.id eq unit.id }) {
            it[GameUnits.positionX] = unit.position.x
            it[GameUnits.positionY] = unit.position.y
            it[GameUnits.health] = unit.health
            it[GameUnits.isAlive] = unit.isAlive
        }
    }
    
    suspend fun getGameSession(sessionId: String): GameState? = DatabaseFactory.dbQuery {
        GameSessions.select { GameSessions.id eq sessionId }
            .mapNotNull { row ->
                Json.decodeFromString<GameState>(row[GameSessions.gameData])
            }
            .singleOrNull()
    }
}
