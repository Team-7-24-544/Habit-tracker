import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';

NavButton createNavButton(NavigationOptions type, NavigationOptions selected, Function goTo) {
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
      return NavButton(icon: 'web/icons/no picture.png', label: 'Error 404', type: type, goTo: goTo);
  }
  icon += '${label.toLowerCase()}.png';
  return NavButton(icon: icon, label: label, isSelected: type == selected, type: type, goTo: goTo);
}

class NavButton extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final Function goTo;
  final NavigationOptions type;

  const NavButton(
      {super.key,
      required this.icon,
      required this.label,
      this.isSelected = false,
      required this.type,
      required this.goTo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              TemplatePage? newPage = goTo(type);
              if (newPage != null) navigateWithAnimation(context, newPage);
            },
            child: Container(
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

  void navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
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
  settings,
  login,
  registration,
}
