class UserProfile {
  String avatarUrl;
  String nickname;
<<<<<<< HEAD
  String about;
  String goal;
  String telegram;
=======
  String aboutMe;
  String goal;
  String telegram;
  String avatarUrl;
>>>>>>> origin/beta
  String monthlyHabits;
  String monthlyQuote;

  UserProfile({
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
