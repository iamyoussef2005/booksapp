import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<double> _cardsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.18, 0.8, curve: Curves.easeOutCubic),
          ),
        );
    _cardsAnimation = Tween<double>(begin: 5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.28, 1, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F1E8), Color(0xFFF0E0CF), Color(0xFFECD4BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const _AmbientShape(
              size: 240,
              top: -56,
              right: -36,
              color: Color(0x33C96F4A),
            ),
            const _AmbientShape(
              size: 320,
              bottom: -120,
              left: -80,
              color: Color(0x1F8B5E3C),
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Spacer(),
                      SlideTransition(
                        position: _titleSlideAnimation,
                        child: Column(
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.78),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 26,
                                    offset: Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: AppIcon(
                                  HugeIcons.strokeRoundedBook01,
                                  color: AppColors.primaryDark,
                                  size: 36,
                                ),
                              ),
                            ),
                            AppSpacing.gapLg,
                            Text(
                              'Book Shop',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: AppColors.primaryDark,
                              ),
                            ),
                            AppSpacing.gapSm,
                            Text(
                              'Curated shelves, warm pages, and your next favorite read.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.gapXl,
                      ScaleTransition(
                        scale: _cardsAnimation,
                        child: const _BookFan(),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.6,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      AppSpacing.gapSm,
                      Text(
                        'Preparing your shelf...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.gapLg,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookFan extends StatelessWidget {
  const _BookFan();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          _CoverCard(
            assetPath: 'assets/The Midnight Library.jpg',
            rotationDegrees: -15,
            horizontalOffset: -92,
            topOffset: 24,
          ),
          _CoverCard(
            assetPath: 'assets/Atomic Habits.jpg',
            rotationDegrees: -6,
            horizontalOffset: -28,
            topOffset: 8,
          ),
          _CoverCard(
            assetPath: 'assets/Dune.jpg',
            rotationDegrees: 5,
            horizontalOffset: 32,
            topOffset: 8,
          ),
          _CoverCard(
            assetPath: 'assets/Project Hail Mary.jpg',
            rotationDegrees: 14,
            horizontalOffset: 96,
            topOffset: 24,
          ),
        ],
      ),
    );
  }
}

class _CoverCard extends StatelessWidget {
  const _CoverCard({
    required this.assetPath,
    required this.rotationDegrees,
    required this.horizontalOffset,
    required this.topOffset,
  });

  final String assetPath;
  final double rotationDegrees;
  final double horizontalOffset;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(horizontalOffset, topOffset),
      child: Transform.rotate(
        angle: rotationDegrees * math.pi / 180,
        child: Container(
          width: 116,
          height: 176,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 26,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Image.asset(assetPath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class _AmbientShape extends StatelessWidget {
  const _AmbientShape({
    required this.size,
    required this.color,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  final double size;
  final Color color;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
