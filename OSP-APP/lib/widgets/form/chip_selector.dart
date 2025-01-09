import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/widgets/headers.dart';

class ChipSelectorField<T extends Object> extends FormBuilderFieldDecoration<List<T>> {
  final List<T> options;
  final String Function(T) elementMatcher;
  final String label;

  ChipSelectorField({
    super.key,
    super.validator,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.initialValue,

    super.enabled,

    super.onSaved,
    super.onReset,
    super.onChanged,

    required this.label,
    required this.options,
    required this.elementMatcher,
    required super.name,
  }) : super(
    builder: (FormFieldState<List<T>?> field) {
      final state = field as _ChipSelectorFieldState<T>;
      final List<T> fieldValue = field.value ?? [];

      Color getBackgroundColor(T element) {
        return fieldValue.contains(element) ? CoreColors.secondary : CoreColors.gray;
      }

      return InputDecorator(
        decoration: state.decoration.copyWith(
          errorBorder: AppLook.disabledBorder(),
          border: AppLook.disabledBorder(),
          focusedBorder: AppLook.disabledBorder(),
          enabledBorder: AppLook.disabledBorder(),
          disabledBorder: AppLook.disabledBorder(),
          errorStyle: const TextStyle(height: 0.1),
          contentPadding: const EdgeInsets.all(0)
        ),
        child: Wrap(
          children: [
            AppHeaderHint(text: label, color: CoreColors.secondary.withOpacity(.6)),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                runSpacing: -10,
                spacing: 0,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,

                children: <Widget>[
                  for (dynamic element in options)
                    ActionChip(
                      color: WidgetStatePropertyAll<Color>(getBackgroundColor(element)),
                      shape: RoundedRectangleBorder(side: BorderSide(color: getBackgroundColor(element)), borderRadius: BorderRadius.circular(50)),
                      visualDensity: VisualDensity.comfortable,

                      label: Text(elementMatcher(element)),
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 13),

                      onPressed: () {
                        if (fieldValue.contains(element)) {
                          fieldValue.remove(element);
                        } else {
                          fieldValue.add(element);
                        }

                        field.didChange(fieldValue);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  );

  @override
  FormBuilderFieldDecorationState<ChipSelectorField<T>, List<T>> createState() => _ChipSelectorFieldState<T>();
}

class _ChipSelectorFieldState<T extends Object> extends FormBuilderFieldDecorationState<ChipSelectorField<T>, List<T>> {}
