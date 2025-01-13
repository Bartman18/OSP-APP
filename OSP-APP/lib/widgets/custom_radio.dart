import 'package:flutter/material.dart';
import 'package:osp/core/appearance.dart';

class CustomRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;
  final String title;
  final String subtitle;
  final String additionalText;

  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    required this.subtitle,
    required this.additionalText,
    this.width = 32,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(this.value);
      },
      child: Container(
        //value == this.value ?
        height: 72,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: groupValue == this.value ? Colors.white : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(13),
          border: groupValue == value ? Border.all(color: CoreColors.primary, width: 2) : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              height: this.height,
              width: this.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                
                color: value == groupValue ? CoreColors.primary.withOpacity(0.4) : Colors.transparent,
                //border: Border.all(width: )
              ),
              child: Center(
                child: Container(
                  height: this.height - 7,
                  width: this.width - 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value == groupValue ? CoreColors.white : Colors.black,
                  ),
                  child: Center(
                    child: Container(
                      height: this.height - 10,
                      width: this.width - 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: value == groupValue ? CoreColors.primary : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontSize,
                          color: CoreColors.black,
                          fontVariations:
                              CoreTheme.boldTextStyle.fontVariations,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .fontSize,
                          color: CoreColors.black,
                          fontVariations:
                              CoreTheme.baseTextStyle.fontVariations,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Center(
              child: Text(
                additionalText,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize:
                          Theme.of(context).textTheme.headlineMedium!.fontSize,
                      color: CoreColors.black,
                      fontVariations: CoreTheme.boldTextStyle.fontVariations,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
