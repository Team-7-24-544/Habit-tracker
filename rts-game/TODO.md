# TODO List - RTS Multiplayer Game

## MVP Завершение (Priority: High)

### Testing
- [ ] Написать unit тесты для GameService
- [ ] Написать integration тесты для database layer
- [ ] Написать E2E тесты для client-server communication
- [ ] Протестировать все типы юнитов в игре
- [ ] Протестировать все типы карт
- [ ] Нагрузочное тестирование (несколько одновременных сессий)

### Bug Fixes
- [ ] Исправить возможные race conditions в GameService
- [ ] Добавить proper error handling для network failures
- [ ] Валидация входных данных на сервере
- [ ] Проверить memory leaks в клиенте

### Documentation
- [ ] Добавить JavaDoc/KDoc комментарии в код
- [ ] Создать API documentation (Swagger/OpenAPI)
- [ ] Видео-туториал по игре
- [ ] Документация для разработчиков (How to contribute)

## Игровой баланс (Priority: High)

### Балансировка юнитов
- [ ] Протестировать все 24 типа юнитов в реальной игре
- [ ] Настроить стоимость каждого юнита
- [ ] Настроить характеристики (HP, атака, защита, скорость)
- [ ] Добавить cooldown на некоторые способности

### Балансировка карт
- [ ] Пересмотреть стоимость карт
- [ ] Добавить больше вариантов карт в колоду
- [ ] Система редкости карт (Common, Rare, Epic)

### Экономика
- [ ] Настроить скорость производства памяти
- [ ] Настроить стартовые ресурсы
- [ ] Добавить инфляцию/дефляцию памяти

## Улучшения геймплея (Priority: Medium)

### Специальные способности юнитов
- [ ] Реализовать уникальные способности для каждого типа
  - [ ] Inheritance Drone: наследование характеристик
  - [ ] Code Injector: баг-инжекция в фабрики
  - [ ] Reflection Spy: сканирование врага
  - [ ] Promise Knight: отложенный урон
  - [ ] Recursive Bomb: рекурсивное деление
  - [ ] RESTful Healer: CRUD операции
  - [ ] Transaction Guard: откат состояния

### AI противник
- [ ] Базовый AI для single-player режима
- [ ] Easy/Medium/Hard сложности
- [ ] Обучающие миссии с AI

### Дополнительные режимы
- [ ] 2v2 режим
- [ ] Free-for-all (3-4 игрока)
- [ ] Ranked режим с рейтингом
- [ ] Tournament режим

### Карты
- [ ] Дополнительные карты с разной топологией
- [ ] Симметричные карты для fair play
- [ ] Карты с препятствиями
- [ ] Генератор случайных карт

## Визуальные улучшения (Priority: Medium)

### Графика
- [ ] Заменить примитивы (квадраты/круги) на спрайты
- [ ] Анимации юнитов (движение, атака, смерть)
- [ ] Particle effects (взрывы, эффекты способностей)
- [ ] Улучшенная UI (меню, HUD)
- [ ] Иконки для карт и юнитов
- [ ] Индикаторы здоровья (health bars)

### Звук
- [ ] Фоновая музыка
- [ ] Звуковые эффекты (атака, смерть юнита, разыгрывание карты)
- [ ] Голосовые подсказки (Unit ready, Under attack)

### UI/UX
- [ ] Миниmap
- [ ] Tooltips для юнитов и карт
- [ ] Анимированные переходы
- [ ] Настройки графики/звука
- [ ] Hotkeys настройка

## Технические улучшения (Priority: Medium)

### Performance
- [ ] Оптимизация рендеринга (batch rendering)
- [ ] Spatial partitioning для collision detection
- [ ] Профилирование и оптимизация GameLoop
- [ ] Уменьшение размера WebSocket сообщений

### Networking
- [ ] Reconnection logic (переподключение при обрыве)
- [ ] Lag compensation
- [ ] Client-side prediction
- [ ] Server reconciliation

### Database
- [ ] Индексы для часто используемых запросов
- [ ] Архивация старых игр
- [ ] Статистика игрока (wins/losses, favorite units)

### Security
- [ ] JWT аутентификация
- [ ] Rate limiting для WebSocket
- [ ] SSL/TLS для production
- [ ] Input validation и sanitization
- [ ] Anti-cheat механизмы

## Платформы (Priority: Low)

### Android
- [ ] Android клиент (LibGDX Android backend)
- [ ] Touch controls адаптация
- [ ] Performance оптимизация для мобильных
- [ ] Google Play Store публикация

### iOS
- [ ] iOS клиент (RoboVM/Multi-OS Engine)
- [ ] Touch controls для iOS
- [ ] App Store публикация

### Web
- [ ] WebGL клиент (LibGDX GWT backend)
- [ ] Browser compatibility testing
- [ ] Responsive design

## Социальные функции (Priority: Low)

### Аккаунты
- [ ] Система регистрации/логина
- [ ] Профили игроков
- [ ] Статистика (win rate, любимые юниты)
- [ ] История игр

### Социальное взаимодействие
- [ ] Система друзей
- [ ] Приглашения в игру
- [ ] In-game чат
- [ ] Эмоции/эмодзи

### Клановая система
- [ ] Создание кланов
- [ ] Clan wars
- [ ] Clan leaderboard
- [ ] Clan чат

### Matchmaking
- [ ] Рейтинговая система (ELO/MMR)
- [ ] Ranked matchmaking
- [ ] Casual matchmaking
- [ ] Custom games (private lobbies)

## Контент (Priority: Low)

### Новые юниты
- [ ] Design Patterns category (Singleton, Factory, Observer)
- [ ] Testing category (Unit Test, Integration Test, E2E Test)
- [ ] DevOps category (CI/CD Pipeline, Container, Orchestrator)
- [ ] Security category (Firewall, Encryption, Authentication)

### Новые карты
- [ ] Direct damage вариации
- [ ] Mass buff/debuff карты
- [ ] AOE карты
- [ ] Карты изменения terrain

### Кампания
- [ ] Обучающие миссии
- [ ] Story mode (10-15 миссий)
- [ ] Boss battles (против супер-AI)

### Косметика
- [ ] Скины для юнитов
- [ ] Темы для игрового поля (Python, Java, Rust, etc.)
- [ ] Кастомизация Instance/Factory
- [ ] Эффекты разыгрывания карт

## DevOps (Priority: Medium)

### CI/CD
- [ ] GitHub Actions для автоматических сборок
- [ ] Автоматические тесты в CI
- [ ] Deployment pipeline
- [ ] Docker образы для сервера

### Monitoring
- [ ] Логирование (структурированное)
- [ ] Метрики (Prometheus/Grafana)
- [ ] Error tracking (Sentry)
- [ ] Performance monitoring

### Infrastructure
- [ ] Kubernetes deployment
- [ ] Horizontal scaling
- [ ] Redis для shared state
- [ ] Load balancing

## Документация (Priority: Medium)

### Для игроков
- [ ] Beginner's guide
- [ ] Advanced tactics guide
- [ ] Unit tier list
- [ ] Meta analysis
- [ ] FAQ

### Для разработчиков
- [ ] Contributing guide
- [ ] Code style guide
- [ ] Architecture deep-dive
- [ ] API documentation
- [ ] Database schema documentation

## Аналитика (Priority: Low)

### Метрики
- [ ] Daily/Monthly active users
- [ ] Average game duration
- [ ] Most popular units
- [ ] Win rates по стратегиям
- [ ] Retention rate

### A/B Testing
- [ ] Тестирование баланса
- [ ] UI/UX эксперименты
- [ ] Monetization experiments

## Монетизация (Priority: Very Low)

### Free-to-Play модель
- [ ] Косметические предметы (скины)
- [ ] Battle Pass система
- [ ] Premium валюта
- [ ] Реклама (с возможностью отключения)

### Payment Integration
- [ ] Stripe/PayPal интеграция
- [ ] In-app purchases (Android/iOS)
- [ ] Subscription модель (Premium account)

## Completed ✓

### MVP
- [x] Базовая структура проекта (shared, server, client)
- [x] Gradle конфигурация
- [x] Модели данных (Unit, Factory, Instance, Card, etc.)
- [x] 24 типа юнитов
- [x] Система карт
- [x] WebSocket communication
- [x] Ktor server с game loop
- [x] LibGDX client с rendering
- [x] PostgreSQL интеграция
- [x] Database schema
- [x] Input handling (mouse, keyboard)
- [x] Basic UI (game board, cards, status)
- [x] Win/loss conditions
- [x] Quick Start guide
- [x] Architecture documentation
- [x] Game Design document
- [x] README файлы

---

## Как использовать этот TODO

1. **Выберите задачу** из списка
2. **Создайте ветку**: `git checkout -b feature/task-name`
3. **Реализуйте** функциональность
4. **Протестируйте** изменения
5. **Создайте PR** с описанием изменений
6. **Отметьте** задачу как выполненную (✓)

## Приоритеты

- **High**: Критично для MVP, должно быть сделано в первую очередь
- **Medium**: Важно для полноценного релиза
- **Low**: Nice to have, можно отложить
- **Very Low**: Долгосрочные планы
