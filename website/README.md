# Website

Название: **Habit tracker**

# Backend

Все файлы находятся в lib/

- main.dart
- models - объекты без визуализации
- pages - страницы сайта
- services - вспомогательные скрипты/функции
- widgets - кастомные виджеты

# User Interface

Все, что не настроено в backend напрямую находиться в web/. Также там (web/icons/) располагаются все картинки,
используемые в сайте.

- icons/navigations - картинки для панели навигации

# Manifest

- pubspecs.yaml - настройка flutter'а

# Run

```
flutter run -d chrome --web-port=8001 --web-hostname=localhost &
```