import 'package:flutter/material.dart';

class DashboardMenuModel {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const DashboardMenuModel({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });
}