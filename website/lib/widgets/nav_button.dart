import 'package:flutter/material.dart';

NavButton createNavButton(NavigationOptions type) {
  String icon = 'web/icons/navigations/', label = '';
  switch (type) {
    case NavigationOptions.home:
      label = 'Home';
      break;
    case NavigationOptions.habits:
      label = 'Habits';
      break;
    case NavigationOptions.newHabit:
      label = 'New habit';
      break;
    case NavigationOptions.groups:
      label = 'Groups';
      break;
    case NavigationOptions.achievements:
      label = 'Achievements';
      break;
    case NavigationOptions.profile:
      label = 'Profile';
      break;
    case NavigationOptions.settings:
      label = 'Settings';
      break;
    default:
      return const NavButton(
          icon: 'web/icons/no picture.png', label: 'Error 404');
  }
  icon += '${label.toLowerCase()}.png';
  return NavButton(icon: icon, label: label);
}

class NavButton extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;

  const NavButton({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade700 : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              icon,
              width: 32,
              height: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

enum NavigationOptions {
  home,
  habits,
  newHabit,
  groups,
  achievements,
  profile,
  settings
}
