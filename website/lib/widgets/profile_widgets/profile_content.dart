import 'package:flutter/material.dart';
import 'package:website/models/MetaKeys.dart';

import '../../models/MetaInfo.dart';
import '../../models/user_profile.dart';
import '../../services/api_manager.dart';
import '../../services/api_query.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  ProfileContentState createState() => ProfileContentState();
}

class ProfileContentState extends State<ProfileContent> {
  UserProfile profile = UserProfile.getDummyProfile();
  bool _loading = true;
  bool isEditing = false;

  final TextEditingController aboutController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController telegramController = TextEditingController();
  final TextEditingController monthlyHabitsController = TextEditingController();
  final TextEditingController monthlyQuoteController = TextEditingController();

  final apiManager = MetaInfo.getApiManager();

  @override
  void initState() {
    super.initState();

    _loadAndApplyProfile();
  }

  Future<void> _loadAndApplyProfile() async {
    final loaded = await _loadProfile();
    if (!mounted) return;
    setState(() {
      final profile = loaded;
      _loading = false;
      aboutController.text = profile.about;
      goalController.text = profile.goal;
      nicknameController.text = profile.nickname;
      telegramController.text = profile.telegram;
      monthlyHabitsController.text = profile.monthlyHabits;
      monthlyQuoteController.text = profile.monthlyQuote;
    });
  }

  Future<UserProfile> _loadProfile() async {
    ApiQuery query = ApiQueryBuilder().path(QueryPaths.getProfile).build();
    ApiResponse response = await apiManager.get(query);

    if (response.success && response.body.keys.contains('profile')) {
      final data = response.body['profile'] as Map<String, dynamic>;

      return UserProfile(
        avatarUrl: data['avatar_url'] ?? '',
        nickname: data['nickname'] ?? '',
        about: data['about'] ?? '',
        goal: data['goal'] ?? '',
        telegram: data['telegram'] ?? '',
        monthlyHabits: data['monthly_habits'] ?? '',
        monthlyQuote: data['monthly_quote'] ?? '',
      );
    }

    return UserProfile.getDummyProfile();
  }

  @override
  void dispose() {
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

  Future<void> _saveProfile() async {
    profile.about = aboutController.text;
    profile.goal = goalController.text;
    profile.nickname = nicknameController.text;
    profile.telegram = telegramController.text;
    profile.monthlyHabits = monthlyHabitsController.text;
    profile.monthlyQuote = monthlyQuoteController.text;

    final query = ApiQueryBuilder()
        .path(QueryPaths.updateProfile)
        .addParameter("avatar_url", profile.avatarUrl)
        .addParameter("nickname", profile.nickname)
        .addParameter("about", profile.about)
        .addParameter("goal", profile.goal)
        .addParameter("telegram", profile.telegram)
        .addParameter("monthly_habits", profile.monthlyHabits)
        .addParameter("monthly_quote", profile.monthlyQuote)
        .build();

    final response = await apiManager.post(query);
    if (!mounted) return;

    if (!response.empty()) {
      setState(() {
        isEditing = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка обновления профиля: ${response.error}")),
      );
    }
  }

  Future<void> _uploadPhoto() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      profile.avatarUrl = 'https://via.placeholder.com/200';
    });
  }

  // Функция для построения секций профиля с контроллером
  Widget _buildProfileSection(
      String label, TextEditingController baseController,
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
                      controller: baseController,
                      maxLines: maxLines,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    )
                  : Text(
                      baseController.text,
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

    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildProfileSection('О себе:', aboutController,
                                maxLines: 5),
                            const SizedBox(height: 24),
                            _buildProfileSection(
                                'Цель/мотивация:', goalController,
                                maxLines: 5),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProfileSection(
                                      'Привычки на месяц:',
                                      monthlyHabitsController,
                                      maxLines: 5),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _buildProfileSection(
                                      'Цитата месяца:', monthlyQuoteController,
                                      maxLines: 5),
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
                              backgroundImage: NetworkImage(
                                  "${MetaInfo.getApiManager().mainUrl}/get_image?user_id=${MetaInfo.instance.get(MetaKeys.userId)}"),
                            ),
                            if (isEditing)
                              IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: _uploadPhoto,
                              ),
                            isEditing
                                ? const SizedBox(height: 10)
                                : const SizedBox(height: 50),
                            _buildProfileSection(
                                'Никнейм:', nicknameController),
                            const SizedBox(height: 24),
                            _buildProfileSection(
                                'Telegram:', telegramController),
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
                        isEditing
                            ? const SizedBox(height: 10)
                            : const SizedBox(height: 50),
                        _buildProfileSection('Никнейм:', nicknameController),
                        const SizedBox(height: 24),
                        _buildProfileSection('Telegram:', telegramController),
                        const SizedBox(height: 24),
                        _buildProfileSection('О себе:', aboutController,
                            maxLines: 5),
                        const SizedBox(height: 24),
                        _buildProfileSection('Цель/мотивация:', goalController,
                            maxLines: 5),
                        const SizedBox(height: 24),
                        _buildProfileSection(
                            'Привычки на месяц:', monthlyHabitsController,
                            maxLines: 8),
                        const SizedBox(height: 24),
                        _buildProfileSection(
                            'Цитата месяца:', monthlyQuoteController,
                            maxLines: 8),
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
