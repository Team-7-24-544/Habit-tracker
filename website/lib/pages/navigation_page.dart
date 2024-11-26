import 'package:flutter/material.dart';
import '../widgets/nav_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left navigation column
          Container(
            width: 80,
            color: Colors.blue.shade900,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                NavButton(
                  icon: 'web/icons/home.png',
                  label: 'Home',
                  isSelected: true,
                ),
                NavButton(
                  icon: 'web/icons/profile.png',
                  label: 'Profile',
                ),
                NavButton(
                  icon: 'web/icons/setting.png',
                  label: 'Settings',
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: const Center(
                child: Text(
                  'Welcome to the Home Page!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}