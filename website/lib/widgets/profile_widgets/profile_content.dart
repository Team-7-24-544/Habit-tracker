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
      {int maxLines = 1, double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
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
              if (isEditing)
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: value),
                    onChanged: onChanged,
                    maxLines: maxLines,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // "О себе" с отступом
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _buildProfileSection(
                              'о себе:',
                              profile.about,
                              (value) => profile.about = value,
                              maxLines: 5,
                              width: 798,
                              height: 158,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // "Цель/мотивация" с отступом
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _buildProfileSection(
                              'цель/мотивация:',
                              profile.goal,
                              (value) => profile.goal = value,
                              maxLines: 5,
                              width: 798,
                              height: 158,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileSection(
                                'привычки на месяц:',
                                profile.monthlyHabits,
                                (value) => profile.monthlyHabits = value,
                                maxLines: 8,
                                width: 386,
                                height: 239,
                              ),
                              const SizedBox(width: 24),
                              _buildProfileSection(
                                'цитата месяца:',
                                profile.monthlyQuote,
                                (value) => profile.monthlyQuote = value,
                                maxLines: 8,
                                width: 386,
                                height: 239,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Right column
                    const SizedBox(width: 24),
                    SizedBox(
                      width: 420,
                      child: Column(
                        children: [
                          // Profile photo
                          Card(
                            elevation: 4,
                            child: SizedBox(
                              width: 234,
                              height: 350,
                              child: Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 75,
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
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildProfileSection(
                            'никнейм:',
                            profile.nickname,
                            (value) => profile.nickname = value,
                            width: 420,
                            height: 97,
                          ),
                          const SizedBox(height: 24),
                          _buildProfileSection(
                            'Telegram:',
                            profile.telegram,
                            (value) => profile.telegram = value,
                            width: 420,
                            height: 97,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
