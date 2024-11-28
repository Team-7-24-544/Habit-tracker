class Emotion {
  final String emoji;
  final String name;

  const Emotion({
    required this.emoji,
    required this.name,
  });
}

class EmotionData {
  static const List<Emotion> emotions = [
    Emotion(emoji: '😊', name: 'happy'),
    Emotion(emoji: '😢', name: 'sad'),
    Emotion(emoji: '😍', name: 'love'),
    Emotion(emoji: '😡', name: 'angry'),
    Emotion(emoji: '😴', name: 'sleepy'),
    Emotion(emoji: '🤔', name: 'thinking'),
    Emotion(emoji: '😎', name: 'cool'),
    Emotion(emoji: '😂', name: 'laughing'),
  ];
}
