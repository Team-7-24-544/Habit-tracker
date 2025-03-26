import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  late UserProfile profile;
  bool isEditing = false;

  // Контроллеры для полей профиля
  late TextEditingController aboutController;
  late TextEditingController goalController;
  late TextEditingController nicknameController;
  late TextEditingController telegramController;
  late TextEditingController monthlyHabitsController;
  late TextEditingController monthlyQuoteController;

  @override
  void initState() {
    super.initState();
    profile = UserProfile.getDummyProfile();

    // Инициализируем контроллеры с данными из профиля
    aboutController = TextEditingController(text: profile.about);
    goalController = TextEditingController(text: profile.goal);
    nicknameController = TextEditingController(text: profile.nickname);
    telegramController = TextEditingController(text: profile.telegram);
    monthlyHabitsController = TextEditingController(text: profile.monthlyHabits);
    monthlyQuoteController = TextEditingController(text: profile.monthlyQuote);
  }

  @override
  void dispose() {
    // Освобождаем ресурсы контроллеров
    aboutController.dispose();
    goalController.dispose();
    nicknameController.dispose();
    telegramController.dispose();
    monthlyHabitsController.dispose();
    monthlyQuoteController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      // Обновляем модель профиля значениями из контроллеров
      profile.about = aboutController.text;
      profile.goal = goalController.text;
      profile.nickname = nicknameController.text;
      profile.telegram = telegramController.text;
      profile.monthlyHabits = monthlyHabitsController.text;
      profile.monthlyQuote = monthlyQuoteController.text;
      isEditing = false;
    });
  }

  Future<void> _uploadPhoto() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      profile.avatarUrl = 'https://via.placeholder.com/200';
    });
  }

  // Функция для построения секций профиля с контроллером
  Widget _buildProfileSection(String label, TextEditingController base_controller,
      {int maxLines = 1}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              isEditing
                  ? TextField(
                      controller: base_controller,
                      maxLines: maxLines,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    )
                  : Text(
                      base_controller.text,
                      style: const TextStyle(fontSize: 16),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Профиль',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: isEditing ? _saveProfile : _toggleEdit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: isEditing ? Colors.green : Colors.blue,
                  ),
                  child: Text(
                    isEditing ? 'Сохранить' : 'Изменить профиль',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Основное содержимое
            isWideScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildProfileSection('О себе:', aboutController, maxLines: 5),
                            const SizedBox(height: 24),
                            _buildProfileSection('Цель/мотивация:', goalController, maxLines: 5),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProfileSection('Привычки на месяц:', monthlyHabitsController, maxLines: 5),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _buildProfileSection('Цитата месяца:', monthlyQuoteController, maxLines: 5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(profile.avatarUrl),
                            ),
                            if (isEditing)
                              IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: _uploadPhoto,
                              ),
                            isEditing ? const SizedBox(height: 10) : const SizedBox(height: 50),
                            _buildProfileSection('Никнейм:', nicknameController),
                            const SizedBox(height: 24),
                            _buildProfileSection('Telegram:', telegramController),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(profile.avatarUrl),
                        ),
                        if (isEditing)
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: _uploadPhoto,
                          ),
                        isEditing ? const SizedBox(height: 10) : const SizedBox(height: 50),
                        _buildProfileSection('Никнейм:', nicknameController),
                        const SizedBox(height: 24),
                        _buildProfileSection('Telegram:', telegramController),
                        const SizedBox(height: 24),
                        _buildProfileSection('О себе:', aboutController, maxLines: 5),
                        const SizedBox(height: 24),
                        _buildProfileSection('Цель/мотивация:', goalController, maxLines: 5),
                        const SizedBox(height: 24),
                        _buildProfileSection('Привычки на месяц:', monthlyHabitsController, maxLines: 8),
                        const SizedBox(height: 24),
                        _buildProfileSection('Цитата месяца:', monthlyQuoteController, maxLines: 8),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
