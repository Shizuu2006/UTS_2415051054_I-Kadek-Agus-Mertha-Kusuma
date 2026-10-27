import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme.dart';

class HighlightCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final bool alt;
  const HighlightCard({
    super.key,
    required this.course,
    required this.onTap,
    this.alt = false,
  });

  Widget _circle(double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: 0.08),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = alt
        ? [AppColors.blue, AppColors.cyan]
        : [AppColors.navy, AppColors.blue];
    final info = course.deadline != null
        ? remainingText(course.deadline!)
        : statusLabel(course.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned(right: -30, top: -30, child: _circle(120)),
              Positioned(right: 30, bottom: -50, child: _circle(100)),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            statusIcon(course.status),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            course.code,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ice,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.flag, size: 14, color: AppColors.ice),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$info • Prioritas ${course.credits}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ice,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
