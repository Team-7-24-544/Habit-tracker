import 'dart:developer';

import 'package:flutter/material.dart';
import '../../models/emotions.dart';
import 'emoji_item.dart';

class EmojiSelector extends StatefulWidget {
  final Function(Emotion) onEmotionSelected;

  const EmojiSelector({
    super.key,
    required this.onEmotionSelected,
  });

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              'Укажите свое настроение сегодня',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 90,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: EmotionData.emotions.length,
                itemBuilder: (context, index) {
                  return EmojiItem(
                    emotion: EmotionData.emotions[index],
                    isSelected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      widget.onEmotionSelected(EmotionData.emotions[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
