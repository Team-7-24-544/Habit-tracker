class UserProfile {
  String nickname;
  String description;
  String goal;
  String telegram;
  String avatarUrl;

  UserProfile({
    this.nickname = '',
    this.description = '',
    this.goal = '',
    this.telegram = '',
    this.avatarUrl = 'https://via.placeholder.com/150',
  });

  // Временная заглушка для демонстрации
  static UserProfile getDummyProfile() {
    return UserProfile(
      nickname: 'FlutterDev',
      description: 'Программирую на Flutter, люблю создавать приложения!',
      goal: 'Улучшить привычки и достичь успеха!',
      telegram: '@flutterdev',
    );
  }
}