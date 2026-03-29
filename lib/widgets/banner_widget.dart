import 'package:flutter/material.dart';
import 'package:e/core/constants/app_color.dart';

class BannerWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String> features;
  final VoidCallback? onButtonTap;
  final String? buttonText;

  const BannerWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.features = const [],
    this.onButtonTap,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 16, color: AppColors.text),
            ),
          ],
          if (features.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (onButtonTap != null && buttonText != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onButtonTap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: Text(buttonText!),
            ),
          ],
        ],
      ),
    );
  }
}
