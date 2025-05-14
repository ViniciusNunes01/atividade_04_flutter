import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;

  const InfoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: Image.asset(iconPath, width: 40),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}