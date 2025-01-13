import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:osp/core/appearance.dart';
import 'package:osp/widgets/headers.dart';

class TagSelectorField<T extends Object> extends FormBuilderFieldDecoration<List<T>> {
  final List<T> options;
  final String Function(T) elementMatcher;
  final String label;

  TagSelectorField({
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
      final state = field as _TagSelectorFieldState<T>;
      final List<T> fieldValue = field.value ?? [];

      double getOpacity(T element) {
        return fieldValue.contains(element) ? 1 : .4;
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
                runSpacing: -5,
                spacing: 0,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,

                children: <Widget>[
                  for (dynamic element in options)
                    ActionChip(
                      color: const WidgetStatePropertyAll<Color>(Colors.transparent),
                      shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.transparent, width: 0), borderRadius: BorderRadius.circular(50)),
                      visualDensity: VisualDensity.compact,

                      label: Text(elementMatcher(element)),
                      labelStyle: TextStyle(color: CoreColors.secondary.withOpacity(getOpacity(element)), fontSize: 13),

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
  FormBuilderFieldDecorationState<TagSelectorField<T>, List<T>> createState() => _TagSelectorFieldState<T>();
}

class _TagSelectorFieldState<T extends Object> extends FormBuilderFieldDecorationState<TagSelectorField<T>, List<T>> {}
