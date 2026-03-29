import 'package:flutter/material.dart';
import 'package:e/core/constants/app_color.dart';

class SizeSelector extends StatelessWidget {
  final List<String> availableSizes;
  final String? selectedSize;
  final Function(String) onSizeSelected;

  const SizeSelector({
    super.key,
    required this.availableSizes,
    this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Size:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: availableSizes.map((size) {
            final isSelected = selectedSize == size;
            return GestureDetector(
              onTap: () => onSizeSelected(size),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.borderGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.text,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
