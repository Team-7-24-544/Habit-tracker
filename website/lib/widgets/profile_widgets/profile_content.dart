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

  @override
  void initState() {
    super.initState();
    profile = UserProfile.getDummyProfile();
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      isEditing = false;
    });
  }

  Future<void> _uploadPhoto() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      profile.avatarUrl = 'https://via.placeholder.com/200';
    });
  }

  Widget _buildProfileSection(String label, String value, Function(String) onChanged,
      {int maxLines = 1}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
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
                    controller: TextEditingController(text: value),
                    onChanged: onChanged,
                    maxLines: maxLines,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
          ],
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
            // Header
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

            // Main content
            isWideScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildProfileSection('О себе:', profile.about, (value) => profile.about = value, maxLines: 5),
                            const SizedBox(height: 24),
                            _buildProfileSection('Цель/мотивация:', profile.goal, (value) => profile.goal = value, maxLines: 5),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProfileSection('Привычки на месяц:', profile.monthlyHabits, (value) => profile.monthlyHabits = value, maxLines: 5),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _buildProfileSection('Цитата месяца:', profile.monthlyQuote, (value) => profile.monthlyQuote = value, maxLines: 5),
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
                            const SizedBox(height: 24),
                            _buildProfileSection('Никнейм:', profile.nickname, (value) => profile.nickname = value),
                            const SizedBox(height: 24),
                            _buildProfileSection('Telegram:', profile.telegram, (value) => profile.telegram = value),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
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
                      const SizedBox(height: 24),
                      _buildProfileSection('Никнейм:', profile.nickname, (value) => profile.nickname = value),
                      const SizedBox(height: 24),
                      _buildProfileSection('Telegram:', profile.telegram, (value) => profile.telegram = value),
                      const SizedBox(height: 24),
                      _buildProfileSection('О себе:', profile.about, (value) => profile.about = value, maxLines: 5),
                      const SizedBox(height: 24),
                      _buildProfileSection('Цель/мотивация:', profile.goal, (value) => profile.goal = value, maxLines: 5),
                      const SizedBox(height: 24),
                      _buildProfileSection('Привычки на месяц:', profile.monthlyHabits, (value) => profile.monthlyHabits = value, maxLines: 8),
                      const SizedBox(height: 24),
                      _buildProfileSection('Цитата месяца:', profile.monthlyQuote, (value) => profile.monthlyQuote = value, maxLines: 8),
                      const SizedBox(height: 24),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
