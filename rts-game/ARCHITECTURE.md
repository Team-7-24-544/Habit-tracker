# Архитектура RTS Multiplayer Game

## Обзор

Проект реализован в виде многомодульного Gradle-проекта с тремя основными модулями:

```
rts-game/
├── shared/      # Общие модели и события
├── server/      # Ktor-сервер
└── client/      # LibGDX-клиент
```

## Модуль: Shared

### Назначение
Содержит все общие модели данных и события, которые используются как сервером, так и клиентом.

### Компоненты

#### Модели данных (`model/`)
- **Position**: 2D координаты на игровом поле
- **Unit**: Игровой юнит с характеристиками (здоровье, атака, защита)
- **UnitType**: Перечисление всех типов юнитов (24 типа)
- **Factory**: Фабрика для производства юнитов
- **Instance**: База игрока (главная цель)
- **MemoryNode**: Узел памяти для захвата ресурсов
- **Player**: Игрок с ресурсами и картами
- **Card**: Карта действия с эффектами
- **Deck**: Колода карт игрока
- **GameState**: Полное состояние игровой сессии

#### События (`event/`)
- **GameEvent**: События от клиента к серверу
  - JoinGame, PlayerReady, PlayCard, MoveUnit, AttackTarget, CaptureNode
- **ServerEvent**: События от сервера к клиенту
  - GameStateUpdate, UnitSpawned, UnitMoved, UnitAttacked, GameEnded, etc.

### Зависимости
- kotlinx-serialization: Сериализация в JSON
- kotlinx-datetime: Работа с датой и временем

## Модуль: Server

### Назначение
Обрабатывает всю игровую логику, управляет состоянием игры, сохраняет данные в БД.

### Архитектурные слои

```
Application (Ktor)
    ↓
Routing (WebSocket/HTTP)
    ↓
Service Layer (GameService)
    ↓
Repository Layer (GameRepository)
    ↓
Database (PostgreSQL + Exposed)
```

### Компоненты

#### Application (`server/Application.kt`)
- Конфигурация Ktor
- Установка плагинов (WebSockets, ContentNegotiation, CORS)
- Инициализация базы данных

#### Routing (`server/routing/GameRoutes.kt`)
- `GET /`: Статус сервера
- `GET /api/session/create`: Создание игровой сессии
- `WS /ws/{sessionId}`: WebSocket для игровых событий

#### Service Layer (`server/service/GameService.kt`)
**Ключевой класс**: Управляет игровыми сессиями

Основные функции:
- `createSession()`: Создание новой игровой сессии
- `handleEvent()`: Обработка входящих событий от клиентов
- `GameSession.startGameLoop()`: Запуск игрового цикла (10 тиков/сек)
- `GameSession.updateGame()`: Обновление состояния игры
- `GameSession.broadcast()`: Отправка событий всем клиентам

Игровой цикл:
```kotlin
while (isRunning) {
    delay(100ms)  // 10 FPS
    
    // Обновление юнитов (AP, движение)
    // Обновление фабрик (производство)
    // Производство ресурсов (память из узлов)
    // Проверка условий победы
    
    broadcast(GameStateUpdate)  // Каждую секунду
}
```

#### Repository Layer (`repository/`)
- **DatabaseFactory**: Настройка HikariCP connection pool
- **Tables**: Определение схемы БД (Exposed DSL)
  - GameSessions
  - GamePlayers
  - GameUnits
- **GameRepository**: CRUD операции для игровых данных

### Зависимости
- Ktor Server (Core, WebSockets, ContentNegotiation, CORS)
- Exposed (ORM для PostgreSQL)
- PostgreSQL JDBC Driver
- HikariCP (Connection Pooling)
- Kotlinx Coroutines

## Модуль: Client

### Назначение
Визуализация игры, обработка пользовательского ввода, связь с сервером.

### Архитектурные компоненты

```
RTSGame (LibGDX Application)
    ↓
Screen Manager
    ↓
┌─────────────┬──────────────┐
│ MenuScreen  │  GameScreen  │
└─────────────┴──────────────┘
         ↓
    NetworkClient
         ↓
    WebSocket Connection
```

### Компоненты

#### RTSGame (`client/RTSGame.kt`)
- Главный класс приложения LibGDX
- Управление экранами (Screen)
- Инициализация NetworkClient

#### MenuScreen (`client/screen/MenuScreen.kt`)
- Главное меню
- Создание/подключение к игровой сессии
- Ожидание второго игрока

#### GameScreen (`client/screen/GameScreen.kt`)
**Основной экран игры**

Функции:
- `render()`: Отрисовка игрового состояния
- `processNetworkEvents()`: Обработка событий от сервера
- `handleInput()`: Обработка ввода (мышь, клавиатура)

Рендеринг:
- Сетка игрового поля
- Базы (Instance) - квадраты
- Фабрики - меньшие квадраты
- Узлы памяти - круги
- Юниты - маленькие круги
- UI (память, карты, статус)

#### NetworkClient (`client/network/NetworkClient.kt`)
**Обработка сетевого взаимодействия**

Функции:
- `createSession()`: HTTP запрос для создания сессии
- `connect()`: Подключение к WebSocket
- `sendEvent()`: Отправка событий на сервер
- `pollEvent()`: Получение событий из очереди

Архитектура:
```kotlin
HttpClient (CIO Engine)
    ↓
WebSocket Session
    ↓
Event Queue (ConcurrentLinkedQueue)
    ↓
Game Logic (processNetworkEvents)
```

### Зависимости
- LibGDX (Core, Backend LWJGL3)
- Ktor Client (WebSockets, CIO)
- Kotlinx Coroutines

## Протокол коммуникации

### Формат сообщений
Все сообщения сериализуются в JSON используя kotlinx-serialization.

### Flow подключения
```
Client                          Server
  |                               |
  |-- GET /api/session/create -->|
  |<-- {sessionId: "..."} --------|
  |                               |
  |-- WS /ws/{sessionId} -------->|
  |                               |
  |-- JoinGame ------------------>|
  |<-- GameStateUpdate -----------|
  |                               |
  |-- PlayerReady --------------->|
  |<-- GameStarted ---------------|
  |                               |
  |<-- GameStateUpdate (1/sec) ---|
  |                               |
  |-- PlayCard ------------------>|
  |<-- UnitSpawned ---------------|
  |                               |
  |-- MoveUnit ------------------>|
  |<-- UnitMoved -----------------|
```

## Игровая логика

### Система ресурсов
- **Memory**: Основной ресурс
- Производство: захваченные узлы памяти → память/сек
- Трата: разыгрывание карт → создание юнитов

### Система карт
- Каждый игрок имеет колоду из 10 карт
- В руке максимум 5 карт
- После розыгрыша карта заменяется новой из колоды
- Типы карт:
  - SPAWN_UNIT: Создание юнита
  - FACTORY_UPGRADE: Улучшение фабрики
  - DIRECT_DAMAGE: Прямой урон
  - HEAL: Лечение
  - BOOST: Усиление

### Система боя
- Урон = Атака атакующего - Защита цели
- Юниты могут атаковать в радиусе 2 клетки
- Атака требует 100 AP (action points)
- AP восстанавливаются со временем (10 AP/тик)

### Условия победы
- Уничтожение Instance противника
- Instance имеет 1000 HP

## База данных

### Схема

```sql
-- Игровые сессии
GameSessions
  id VARCHAR(50) PK
  status VARCHAR(20)
  winner_id VARCHAR(50)
  created_at TIMESTAMP
  finished_at TIMESTAMP
  game_data TEXT  -- JSON snapshot

-- Игроки
GamePlayers
  id VARCHAR(50) PK
  session_id VARCHAR(50) FK
  name VARCHAR(100)
  memory INT
  is_winner BOOLEAN

-- Юниты
GameUnits
  id VARCHAR(50) PK
  session_id VARCHAR(50) FK
  owner_id VARCHAR(50)
  unit_type VARCHAR(50)
  position_x INT
  position_y INT
  health INT
  is_alive BOOLEAN
  created_at TIMESTAMP
```

### Стратегия персистентности
- **В реальном времени**: Сохранение важных событий (создание юнита, смерть)
- **По завершении**: Полный snapshot игрового состояния
- **Для аналитики**: История всех игр в БД

## Масштабируемость

### Текущие ограничения MVP
- Один сервер
- Максимум 2 игрока на сессию
- Состояние в памяти (sessions ConcurrentHashMap)

### Возможные улучшения
1. **Кластеризация**: Redis для shared state
2. **Load Balancing**: Nginx → Multiple server instances
3. **Persistent State**: Redis/Hazelcast вместо in-memory
4. **Matchmaking Service**: Отдельный микросервис
5. **Analytics Service**: Kafka + Processing

## Безопасность

### Текущая реализация
- Server-authoritative: вся логика на сервере
- Валидация всех действий игрока
- WebSocket без аутентификации (MVP)

### Рекомендации для продакшена
1. JWT токены для аутентификации
2. Rate limiting на WebSocket сообщения
3. SSL/TLS для WebSocket (wss://)
4. Валидация всех входных данных
5. Защита от SQL injection (используется Exposed ORM)

## Тестирование

### Стратегия (TODO)
- **Unit Tests**: Бизнес-логика (GameService, models)
- **Integration Tests**: Database layer
- **E2E Tests**: Client-Server взаимодействие
- **Load Tests**: Множество клиентов, долгие игры

### Инструменты
- JUnit 5
- Ktor Test Framework
- Mockk для моков
