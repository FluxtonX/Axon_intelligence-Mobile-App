import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class PortfolioGallery extends StatelessWidget {
  const PortfolioGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Portfolio',
              style: AppTypography.headingMedium.copyWith(
                color: const Color(0xFF111827),
                fontSize: 20,
              ),
            ),
            Text(
              'View all',
              style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildPortfolioItem(
                context,
                'assets/portfolio/portfolio_1.png',
                'Fintech UI Kit',
                'Mobile App Design',
              ),
              const SizedBox(width: 16),
              _buildPortfolioItem(
                context,
                'assets/portfolio/portfolio_2.png',
                'Brand Identity',
                '3D Illustration',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioItem(BuildContext context, String assetPath, String title, String category) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTypography.headingSmall.copyWith(color: const Color(0xFF111827)),
                            ),
                            Text(
                              category,
                              style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7280)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      assetPath,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: const Color(0xFFF3F4F6),
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_rounded, color: Color(0xFF9CA3AF), size: 48),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  assetPath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF3F4F6),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_rounded, color: Color(0xFF9CA3AF), size: 40),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
