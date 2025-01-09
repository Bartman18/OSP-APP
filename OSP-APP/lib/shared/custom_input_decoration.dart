import 'package:flutter/material.dart';
import 'package:fox_core/core/appearance.dart';

const double defaultInputPadding = 16.0;

final TextStyle errorStyle = CoreTheme.get()
    .textTheme
    .labelSmall!
    .copyWith(color: Colors.red, fontVariations: CoreTheme.semiBoldTextStyle.fontVariations);

InputBorder inputEnabledBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent),
  borderRadius: BorderRadius.all(
    Radius.circular(30),
  ),
);

InputDecoration customInputDecoration({double paddingValue = defaultInputPadding}) =>
    InputDecoration(
      fillColor: CoreColors.white,
      filled: true,
      errorBorder: inputEnabledBorder.copyWith(
          borderSide: const BorderSide(color: Colors.red, style: BorderStyle.solid, width: 2.0)),
      enabledBorder: inputEnabledBorder,
      focusedBorder: inputEnabledBorder,
      focusedErrorBorder: inputEnabledBorder,
      border: inputEnabledBorder,
      contentPadding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue),
      prefixIconConstraints: BoxConstraints(maxHeight: paddingValue),
    );
