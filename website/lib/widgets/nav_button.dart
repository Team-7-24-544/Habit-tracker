import 'package:flutter/material.dart';

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