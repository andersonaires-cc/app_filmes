import 'package:flutter/material.dart';

class FilmeTile extends StatelessWidget {
  final String filme;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  FilmeTile({required this.filme, required this.onTap, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(filme),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
