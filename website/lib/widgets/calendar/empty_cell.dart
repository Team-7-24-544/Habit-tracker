import 'package:flutter/material.dart';

TableCell createEmptyCell() {
  return const TableCell(child: EmptyCell());
}

class EmptyCell extends StatelessWidget {
  const EmptyCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50,
      child: Center(
        child: Text(
          "",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
