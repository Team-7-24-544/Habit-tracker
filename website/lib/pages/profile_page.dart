import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';
import 'package:flutter/material.dart';


class ProfilePage extends TemplatePage {
  final String title = 'Profile Page';
  final NavigationOptions page = NavigationOptions.profile;

  const ProfilePage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);

  @override
  Widget getMainArea() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150', // Ссылка на аватарку
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Никнейм: FlutterDev',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Описание: Программирую на Flutter, люблю создавать приложения!',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Цель/мотивация: Улучшить привычки и достичь успеха!',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Telegram: @flutterdev',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
