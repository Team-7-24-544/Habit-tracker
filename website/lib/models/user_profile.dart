class UserProfile {
  int user_id;
  String avatarUrl;
  String nickname;
  String about;
  String goal;
  String telegram;
  String monthlyHabits;
  String monthlyQuote;

  UserProfile({
    required this.user_id,
    required this.avatarUrl,
    required this.nickname,
    required this.about,
    required this.goal,
    required this.telegram,
    required this.monthlyHabits,
    required this.monthlyQuote,
  });

  // Для тестирования добавляем метод создания "заглушки"
  static UserProfile getDummyProfile() {
    return UserProfile(
      user_id: 1,
      avatarUrl: 'https://via.placeholder.com/200',
      nickname: 'JohnDoe',
      about: 'Flutter Developer',
      goal: 'Create beautiful apps',
      telegram: '@johndoe',
      monthlyHabits: 'Read a book, Practice coding',
      monthlyQuote: 'Keep pushing forward!',
    );
  }
}
