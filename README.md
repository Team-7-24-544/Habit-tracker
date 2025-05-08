# Habit-tracker

# Состав команды:

- Панов А. М. (группа Б24-544)
- Гранкин Л. В. (группа Б24-544)
- Степанов А. Г. (группа Б24-544)
- Кураев Н. И. (группа Б24-544)

# Описание проекта

Habit Tracker — это удобный онлайн-инструмент, который помогает вам
отслеживать и развивать полезные привычки.
С нашей платформой вы можете легко записывать, анализировать и
управлять своими привычками, чтобы достигать личных целей.

Доска с планом и различной полезной информацией:
https://miro.com/app/board/uXjVLKXa9bc=/?share_link_id=662774377792

# Особенности

- Календарь настроения и выполнения планов
- Гибкая настройка при добавлении новых привычек
- Изменение графика освоения новой привычки в зависимости от настроения/успехов пользователя (в разработке)
- Возможность выбора свободных дней в графике освоения привычки
- Сравнение самочувствия пользователя до и после освоения привычки (в разработке)
- Достижения за освоение привычек
- Приобретение привычки группой (в разработке)
- Создание вызовов для себя и других пользователей (в разработке)
- ~~Статьи и советы~~
- Возможность делиться достижениями (в разработке)
- Отправка напоминаний

# Реализация

- Website
    - Flutter + Dart
- Telegram-bot
    - telegram-библиотека
- Backend
    - Python + FastAPI
- Database
    - SQLite

Взаимодействие backend <--> web происходит через Https \
Взаимодействие backend ---> bot происходит через Redis

Подробнее см. в Readme конкретного модуля

# Запуск

Для запуска требуется Flutter, Dart, Redis + библиотеки для Python и Dart. Также требуется SSL-сертификат для Https и
токен для телеграм-бота

Скачать \
[Flutter](https://docs.flutter.dev/get-started/install) \
[Dart](https://dart.dev/get-dart)

Запуск Redis

```shell
brew services start redis # MacOS

sudo service redis-server start # Linux

redis-server # Windows + WSL
```

Запуск сайта:

```shell
cd website
flutter pub get
# при необходимости можно заменить Chrome на другой поддерживаемый браузер
flutter run -d chrome --web-port=8001 --web-hostname=localhost 
```

Запуск сервера (для запуска необходим сертификат SSL в папке backend/data/):

```shell
cd backend
pip install -r requirements.txt
uvicorn main:app --host 127.0.0.1 --port 5000 --ssl-keyfile=data/key.pem --ssl-certfile=data/cert.pem &
```

Запуск телеграм-бота:

```shell
cd tg-bot
pip install -r requirements.txt
python main.py
```
