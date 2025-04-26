import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  final String groupName;
  final List<String> members;

  const GroupHeader({
    super.key,
    required this.groupName,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              groupName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: members.map((member) => _buildMemberChip(member)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberChip(String member) {
    return Chip(
      avatar: CircleAvatar(
        child: Text(
          member[0].toUpperCase(),
          style: const TextStyle(fontSize: 12),
        ),
      ),
      label: Text(member),
      backgroundColor: Colors.blue.shade100,
    );
  }
}