import 'package:flutter/material.dart';

class RecentAchievement {
  final String username;
  final String achievementName;
  final String date;
  final int reactions;
  final bool hasReacted;

  const RecentAchievement({
    required this.username,
    required this.achievementName,
    required this.date,
    this.reactions = 0,
    this.hasReacted = false,
  });
}

class RecentAchievements extends StatefulWidget {
  final List<RecentAchievement> achievements;

  const RecentAchievements({
    super.key,
    required this.achievements,
  });

  @override
  State<RecentAchievements> createState() => _RecentAchievementsState();
}

class _RecentAchievementsState extends State<RecentAchievements> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Недавние достижения',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.achievements.length,
              itemBuilder: (context, index) {
                final achievement = widget.achievements[index];
                return _buildAchievementItem(achievement);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(RecentAchievement achievement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Text(achievement.username[0].toUpperCase()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(achievement.achievementName),
                const SizedBox(height: 4),
                Text(
                  achievement.date,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  achievement.hasReacted ? Icons.favorite : Icons.favorite_border,
                  color: achievement.hasReacted ? Colors.red : null,
                ),
                onPressed: () {
                  // TODO: Implement reaction logic
                },
              ),
              Text(
                achievement.reactions.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}