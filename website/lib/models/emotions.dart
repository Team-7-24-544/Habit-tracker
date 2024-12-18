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
    Emotion(emoji: '😩', name: 'very_disappointed'),
    Emotion(emoji: '😖', name: 'frustrated'),
    Emotion(emoji: '😔', name: 'sad'),
    Emotion(emoji: '😕', name: 'disappointed'),
    Emotion(emoji: '😐', name: 'neutral'),
    Emotion(emoji: '😌', name: 'relieved'),
    Emotion(emoji: '🙂', name: 'slightly_happy'),
    Emotion(emoji: '😊', name: 'happy'),
    Emotion(emoji: '😄', name: 'joyful'),
    Emotion(emoji: '😁', name: 'proud'),
    Emotion(emoji: '🏆', name: 'triumphant'),
  ];
}
