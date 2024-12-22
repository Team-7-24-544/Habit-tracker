import 'package:website/pages/template_page.dart';
import '../widgets/nav_button.dart';
import '../models/user_profile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends TemplatePage {
  @override
  String get title => 'Profile Page';

  @override
  NavigationOptions get page => NavigationOptions.profile;

  const ProfilePage({super.key});

  @override
  Widget getMainArea() {
    return ProfileContent();
  }
}

class ProfileContent extends StatefulWidget {
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
    // Заглушка для выбора фото
    await Future.delayed(const Duration(seconds: 1)); // Симуляция задержки
    setState(() {
      profile.avatarUrl = 'https://via.placeholder.com/200'; // Временное фото
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profile.avatarUrl),
                  ),
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: _uploadPhoto,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileField(
                      'Никнейм',
                      profile.nickname,
                      (value) => profile.nickname = value,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileField(
                      'О себе',
                      profile.aboutMe,
                      (value) => profile.aboutMe = value,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileField(
                      'Цель/мотивация',
                      profile.goal,
                      (value) => profile.goal = value,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileField(
                      'Telegram',
                      profile.telegram,
                      (value) => profile.telegram = value,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileField(
                      'Привычки на месяц',
                      profile.monthlyHabits,
                      (value) => profile.monthlyHabits = value,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileField(
                      'Цитата месяца',
                      profile.monthlyQuote,
                      (value) => profile.monthlyQuote = value,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    String value,
    Function(String) onChanged, {
    int maxLines = 1,
  }) {
    return Column(
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
        if (isEditing)
          TextField(
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
      ],
    );
  }
}