import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _AppTitle(),
                    const SizedBox(height: 40),
                    _buildFeatureSection(
                      title: 'Гибкие настройки привычек',
                      content:
                          'Создавайте уникальные трекеры с индивидуальными параметрами:\n• Несколько типов отслеживания\n• Гибкие временные интервалы\n• Кастомизируемые напоминания',
                      imageLabel: 'Пример интерфейса создания привычки',
                    ),
                    _buildFeatureSection(
                      title: 'Удобное отслеживание',
                      content:
                          'Визуализируйте свой прогресс с помощью:\n• Интерактивного календаря\n• Графиков прогресса\n• Статистики за любой период',
                      imageLabel: 'Календарь настроения с цветовыми отметками',
                    ),
                    _buildFeatureSection(
                      title: 'Телеграм-интеграция',
                      content:
                          'Основные возможности бота:\n• Умные напоминания\n• Быстрый ввод данных\n• Ежедневная статистика\n• Мотивационные сообщения',
                      imageLabel: 'Пример чата с ботом',
                    ),
                    const SizedBox(height: 30),
                    _buildInfoCard(),
                    const SizedBox(height: 40),
                    _buildFuturePlans(),
                    const SizedBox(height: 40),
                    _buildBottomText(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              Positioned(
                top: 30,
                left: 20,
                child: _buildBackButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSection(
      {required String title,
      required String content,
      required String imageLabel}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildImagePlaceholder(imageLabel),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(String label) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline, color: Colors.deepPurple, size: 28),
          const SizedBox(height: 15),
          Text(
            'Для работы с ботом:\n1. Укажите Telegram-ник (без @) в профиле\n2. Начните диалог с @HabitTracker_123_bot\n3. Ник можно изменить в настройках',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuturePlans() {
    return Column(
      children: [
        const Text(
          'Скоро в обновлениях:',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 20),
        _buildPlanItem('🏆 Система достижений',
            'Открывайте уникальные ачивки за ваши успехи'),
        _buildPlanItem(
            '👥 Группы и сообщества', 'Соревнуйтесь и мотивируйте друг друга'),
        _buildPlanItem('📊 Расширенная аналитика',
            'Глубокая статистика и персональные инсайты'),
      ],
    );
  }

  Widget _buildPlanItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 30,
      ),
    );
  }

  Widget _buildBottomText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Присоединяйтесь к нам!\nСделайте свою жизнь более осознанной',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[700],
          fontStyle: FontStyle.italic,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, size: 28),
      color: Colors.deepPurple,
      onPressed: () => Navigator.pop(context),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.9),
        padding: const EdgeInsets.all(12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Habit Tracker',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Интерактивный трекер привычек',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
