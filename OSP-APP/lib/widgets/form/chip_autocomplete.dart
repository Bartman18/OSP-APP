import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:osp/core/appearance.dart';

class ChipAutocompleteField<T extends Object> extends FormBuilderFieldDecoration<List<T>> {
  final List<T> options;
  final String Function(T) elementMatcher;
  final Color? cursorColor;
  final TextStyle? style;

  ChipAutocompleteField({
    super.key,
    super.decoration,
    super.validator,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.initialValue,
    super.enabled,
    super.onSaved,
    super.onReset,
    super.onChanged,
    required this.options,
    required this.elementMatcher,
    required super.name,
    this.cursorColor,
    this.style,
  }) : super(
      builder: (FormFieldState<List<T>?> field) {
        final state = field as _ChipAutocompleteFieldState<T>;
        final List<T> fieldValue = field.value ?? [];

        Widget dropdown = TypeAheadField<T>(
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: decoration,
              cursorColor: cursorColor,
              style: style,
            );
          },
          suggestionsCallback: (search) => options.where((element) {
            return elementMatcher(element).toString().toLowerCase().contains(search.toLowerCase());
          }).toList(),
          onSelected: (selected) {
            if (fieldValue.contains(selected)) {
              return;
            }
            fieldValue.add(selected);
            field.didChange(fieldValue);
          },
          itemBuilder: (context, element) {
            return ListTile(
              title: Text(elementMatcher(element)),
            );
          },
        );

        return InputDecorator(
          decoration: state.decoration.copyWith(
            errorBorder: AppLook.disabledBorder(),
            border: AppLook.disabledBorder(),
            focusedBorder: AppLook.disabledBorder(),
            enabledBorder: AppLook.disabledBorder(),
            disabledBorder: AppLook.disabledBorder(),
            errorStyle: const TextStyle(height: .1),
            contentPadding: const EdgeInsets.all(0),
            labelText: '',
          ),
          child: Column(
            children: [
              dropdown,
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.infinity,
                child: Wrap(
                  runSpacing: -5,
                  spacing: 5,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    for (dynamic element in fieldValue)
                      Chip(
                        backgroundColor: CoreColors.black,
                        label: Text(elementMatcher(element)),
                        onDeleted: () {
                          fieldValue.remove(element);
                          field.didChange(fieldValue);
                        },
                        deleteIcon: const Icon(Icons.close_outlined, size: 15),
                        side: BorderSide(
                          color: CoreColors.black,
                        ),
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
  FormBuilderFieldDecorationState<ChipAutocompleteField<T>, List<T>> createState() => _ChipAutocompleteFieldState<T>();
}

class _ChipAutocompleteFieldState<T extends Object> extends FormBuilderFieldDecorationState<ChipAutocompleteField<T>, List<T>> {}
