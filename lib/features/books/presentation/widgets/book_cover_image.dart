import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_icon.dart';

class BookCoverImage extends StatelessWidget {
  const BookCoverImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = 24,
    this.fit = BoxFit.cover,
    this.heroTag,
  });

  final String imageUrl;
  final double borderRadius;
  final BoxFit fit;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final imageContent = imageUrl.startsWith('assets/')
        ? Image.asset(
            imageUrl,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _fallbackCover(),
          )
        : Image.network(
            imageUrl,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _fallbackCover(),
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                return child;
              }

              return Container(
                color: AppColors.surfaceSoft,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              );
            },
          );

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageContent,
    );

    if (heroTag == null) {
      return image;
    }

    return Hero(
      tag: heroTag!,
      child: image,
    );
  }

  Widget _fallbackCover() {
    return Container(
      color: AppColors.surfaceSoft,
      alignment: Alignment.center,
      child: const AppIcon(
        HugeIcons.strokeRoundedBook01,
        color: AppColors.primary,
        size: 42,
      ),
    );
  }
}
