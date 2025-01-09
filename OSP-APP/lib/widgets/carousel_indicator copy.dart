import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  final int amount;
  final int currentIndex;
  final MainAxisAlignment mainAxisAlign;

  const CarouselIndicator({super.key, required this.amount, required this.currentIndex, this.mainAxisAlign = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlign,
      children: List.generate(
        amount,
        (index) => _buildIndicator(index + 1),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    double indicatorSize = 7;
    double selectedIndicatorSize = 20;
    Color indicatorColor = Colors.white.withOpacity(.9);
    Color selectedIndicatorColor = Colors.white.withOpacity(.9);

    bool isSelected = index == currentIndex;

    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 10, right: 5),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isSelected ? selectedIndicatorSize : indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isSelected ? selectedIndicatorColor : indicatorColor,
      ),
    );
  }
}
