# Database Manager

Backend проекта реализован с использованием **FastAPI** и **SQLite**. Эта часть отвечает за управление данными
пользователей, привычек, достижений и календарей.

# Структура

- database
    - main.py # Точка входа, определение приложения FastAPI.
    - logging_config.py # Настройка логирования.
    - models.py # ORM-модели для работы с SQLite.
    - database.py # Подключение и управление базой данных.
    - achievements.py # API и логика для работы с достижениями.
    - emoji_calendar.py # API и логика работы с календарем.
    - habits.py # API для работы с привычками.
    - users.py # API для управления пользователями.
    - data
        - example.sqlite # Пример базы данных.
        - app.log # Файл для логов приложения.
        - key.pem, cert.pem # Сертификат для Https
        - app.log # Лог-файл

# Запуск

Для запуска сервера необходимо ввести в консоль директории database команду:

`uvicorn main:app --host 127.0.0.1 --port 5000 --ssl-keyfile=data/key.pem --ssl-certfile=data/cert.pem &`

Замечание: сертификат должен находится в database/data/