import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';
import '../models/user_profile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends TemplatePage {
  final String title = 'Profile Page';
  final NavigationOptions page = NavigationOptions.profile;

  const ProfilePage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);

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
    // Используем временную заглушку
    profile = UserProfile.getDummyProfile();
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    // TODO: Здесь будет логика сохранения в API
    setState(() {
      isEditing = false;
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
            // Верхняя секция с аватаром и кнопкой редактирования
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Профиль',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(isEditing ? Icons.save : Icons.edit),
                  onPressed: isEditing ? _saveProfile : _toggleEdit,
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Секция с аватаром
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
                          icon: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: () {
                            // TODO: Добавить логику загрузки изображения
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Информация профиля
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileField(
                      'Никнейм',
                      profile.nickname,
                      (value) => profile.nickname = value,
                    ),
                    SizedBox(height: 16),
                    _buildProfileField(
                      'Описание',
                      profile.description,
                      (value) => profile.description = value,
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    _buildProfileField(
                      'Цель/мотивация',
                      profile.goal,
                      (value) => profile.goal = value,
                      maxLines: 2,
                    ),
                    SizedBox(height: 16),
                    _buildProfileField(
                      'Telegram',
                      profile.telegram,
                      (value) => profile.telegram = value,
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
        SizedBox(height: 8),
        if (isEditing)
          TextField(
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
      ],
    );
  }
}