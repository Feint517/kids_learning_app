import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kids_learning_app/features/practice/controllers/association/association_controller.dart';
import 'package:kids_learning_app/features/practice/models/size_comparison_item.dart';
import 'package:kids_learning_app/utils/constants/colors.dart';

class SizeComparisonContent extends GetView<AssociationController> {
  const SizeComparisonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                controller.currentExercise.itemGroup.category,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDeep,
                ),
              ),
            ),
            const Gap(10),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.orange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 18),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      "Sélectionne l'image la plus grande.",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconForGroup(
                    controller.currentExercise.itemGroup.groupName,
                  ),
                  color: AppColors.primaryDeep,
                  size: 22,
                ),
                const Gap(8),
                Text(
                  controller.currentExercise.itemGroup.groupName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDeep,
                  ),
                ),
              ],
            ),
            const Gap(15),

            LayoutBuilder(
              builder: (context, constraints) {
                final imageAreaWidth = constraints.maxWidth / 3;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      controller.currentExercise.itemGroup.sizeOptions
                          .map<Widget>(
                            (option) => _buildSelectableItem(
                              context,
                              controller.currentExercise.itemGroup,
                              option,
                              '${controller.currentExercise.itemGroup.groupName}_${option.size}',
                              imageAreaWidth,
                            ),
                          )
                          .toList(),
                );
              },
            ),

            const Gap(15),
            LinearProgressIndicator(
              value:
                  (controller.currentExerciseIndex.value + 1) /
                  controller.currentExercises.length,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            const Gap(5),
            Center(
              child: Text(
                "${controller.currentExerciseIndex.value + 1}/${controller.currentExercises.length}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForGroup(String groupName) {
    switch (groupName.toLowerCase()) {
      case "hippopotames":
      case "cerfs":
      case "chiens":
      case "pandas":
        return Icons.pets;
      case "vélos":
        return Icons.directions_bike;
      case "marteaux":
        return Icons.hardware;
      case "lunettes":
        return Icons.visibility;
      case "stylos":
        return Icons.edit;
      default:
        return Icons.category;
    }
  }

  Widget _buildSelectableItem(
    BuildContext context,
    ItemGroup group,
    SizeOption option,
    String itemId,
    double areaWidth,
  ) {
    final imageSize = areaWidth * option.scale * 0.9;

    final isSelected = option.isLargestSelected;

    final isCorrectAnswer = option.size == "grand";

    return SizedBox(
      width: areaWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (!controller.isAnswerValidated.value) {
                  _handleItemTap(option);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: Image.asset(
                  group.imagePath,
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.transparent,
                      height: imageSize,
                      width: imageSize,
                      child: Icon(
                        Icons.image_not_supported,
                        size: imageSize / 2.5,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          Obx(
            () =>
                isSelected.value
                    ? _buildCircleAnimation(imageSize)
                    : SizedBox(),
          ),

          if (controller.isAnswerValidated.value && isSelected.value) ...[
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isCorrectAnswer ? AppColors.accent : AppColors.accent2,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrectAnswer ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleItemTap(SizeOption option) {
    controller.selectLargestItem(option.size);
  }

  Widget _buildCircleAnimation(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return CustomPaint(
            size: Size(size, size),
            painter: CircleAnimationPainter(
              progress: value,
              color: AppColors.primary,
              strokeWidth: 4.0,
            ),
          );
        },
      ),
    );
  }
}

class CircleAnimationPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircleAnimationPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2) - 2;

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleAnimationPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
