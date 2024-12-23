import 'package:flutter/material.dart';
import 'template_page.dart';
import '../widgets/navigation_widgets/nav_button.dart';
import '../widgets/profile_widgets/profile_content.dart';

class ProfilePage extends TemplatePage {
  @override
  String get title => 'Профиль';

  @override
  NavigationOptions get page => NavigationOptions.profile;

  const ProfilePage({super.key});

  @override
  Widget getMainArea() {
    return const ProfileContent(); // Отображаем содержимое через `ProfileContent`
  }
}
