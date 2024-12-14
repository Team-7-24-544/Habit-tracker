import 'package:flutter/material.dart';

TableCell createEmptyCell() {
  return const TableCell(child: EmptyCell());
}

const calendarCellSize = 55.0;

class EmptyCell extends StatelessWidget {
  final double height = calendarCellSize;

  const EmptyCell({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: Text(
          "",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
