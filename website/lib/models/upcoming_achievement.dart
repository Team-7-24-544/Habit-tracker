class UpcomingAchievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final double progress;
  final double maxProgress;

  UpcomingAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.progress,
    required this.maxProgress,
  });

  double get progressPercentage => (progress / maxProgress) * 100;
}