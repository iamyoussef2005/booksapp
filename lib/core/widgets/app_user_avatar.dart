import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class AppUserAvatar extends StatelessWidget {
  const AppUserAvatar({
    super.key,
    this.fullName,
    this.email,
    this.radius = 15,
  });

  final String? fullName;
  final String? email;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initials = _buildInitials(fullName, email);

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceSoft,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primaryDark,
          fontSize: radius * 0.72,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _buildInitials(String? fullName, String? email) {
    final source = (fullName?.trim().isNotEmpty ?? false)
        ? fullName!.trim()
        : (email?.split('@').first ?? 'Reader');

    final parts = source
        .split(RegExp(r'[\s._-]+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'R';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
