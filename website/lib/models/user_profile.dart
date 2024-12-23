class UserProfile {
  String nickname;
  String aboutMe;
  String goal;
  String telegram;
  String avatarUrl;
  String monthlyHabits;
  String monthlyQuote;

  UserProfile({
    this.nickname = '',
    this.aboutMe = '',
    this.goal = '',
    this.telegram = '',
    this.avatarUrl = 'https://via.placeholder.com/150',
    this.monthlyHabits = '',
    this.monthlyQuote = '',
  });

  // Временная заглушка для демонстрации
  static UserProfile getDummyProfile() {
    return UserProfile(
      nickname: 'Vasy Pupkin',
      aboutMe: 'Программирую на Flutter, люблю создавать приложения!',
      goal: 'Улучшить привычки и достичь успеха!',
      telegram: '@vasek',
      monthlyHabits: 'Бег по утрам, Чтение книг, Медитация',
      monthlyQuote: 'Путь в тысячу ли начинается с первого шага',
    );
  }
}