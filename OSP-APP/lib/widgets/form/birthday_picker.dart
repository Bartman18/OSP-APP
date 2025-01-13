import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:osp/core/appearance.dart';

/// This class is just a copy-paste from form_builder_date_time_picker
/// but simplified to provide birthday and zodiac sign selection only.
class BirthdayPicker extends FormBuilderFieldDecoration<DateTime> {
  /// For representing the date as a string e.g.
  /// `DateFormat("EEEE, MMMM d, yyyy 'at' h:mma")`
  /// (Sunday, June 3, 2018 at 9:24pm)
  final DateFormat? format;

  /// The date the calendar opens to when displayed. Defaults to the current date.
  ///
  /// To preset the widget's value, use [initialValue] instead.
  final DateTime? initialDate;

  /// The earliest choosable date. Defaults to 1900.
  final DateTime? firstDate;

  /// The latest choosable date. Defaults to 2100.
  final DateTime? lastDate;

  final DateTime? currentDate;

  /// The initial time prefilled in the picker dialog when it is shown. Defaults
  /// to noon. Explicitly set this to `null` to use the current time.
  final TimeOfDay initialTime;

  /// Corresponds to the [showDatePicker()] parameter. Defaults to
  /// [DatePickerMode.day].
  final DatePickerMode initialDatePickerMode;

  /// Corresponds to the [showDatePicker()] parameter.
  ///
  /// See [GlobalMaterialLocalizations](https://docs.flutter.io/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html)
  /// for acceptable values.
  final Locale? locale;

  /// Corresponds to the [showDatePicker()] parameter.
  final ui.TextDirection? textDirection;

  /// Corresponds to the [showDatePicker()] parameter.
  final bool useRootNavigator;

  /// Called when an enclosing form is submitted. The value passed will be
  /// `null` if [format] fails to parse the text.
  final ValueChanged<DateTime?>? onFieldSubmitted;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  /// Preset the widget's value.
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TransitionBuilder? transitionBuilder;

  final bool showCursor;

  final int? minLines;

  final bool expands;

  final TextInputAction? textInputAction;

  final VoidCallback? onEditingComplete;

  final InputCounterWidgetBuilder? buildCounter;
  final MouseCursor? mouseCursor;

  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;

  final double cursorWidth;
  final TextCapitalization textCapitalization;

  final String? cancelText;
  final String? confirmText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final String? helpText;
  final DatePickerEntryMode initialEntryMode;
  final RouteSettings? routeSettings;

  final TimePickerEntryMode timePickerInitialEntryMode;
  final StrutStyle? strutStyle;
  final SelectableDayPredicate? selectableDayPredicate;
  final Offset? anchorPoint;
  final EntryModeChangeCallback? onEntryModeChanged;

  /// Creates field for `Date`, `Time` and `DateTime` input
  BirthdayPicker({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.cursorWidth = 2.0,
    this.enableInteractiveSelection = true,
    this.initialTime = const TimeOfDay(hour: 12, minute: 0),
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.expands = false,
    this.initialDatePickerMode = DatePickerMode.day,
    this.transitionBuilder,
    this.textCapitalization = TextCapitalization.none,
    this.useRootNavigator = true,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.timePickerInitialEntryMode = TimePickerEntryMode.dial,
    this.format,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.currentDate,
    this.locale,
    this.maxLength,
    this.textDirection,
    this.textAlignVertical,
    this.onFieldSubmitted,
    this.controller,
    this.style,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    this.inputFormatters,
    this.showCursor = false,
    this.minLines,
    this.textInputAction,
    this.onEditingComplete,
    this.buildCounter,
    this.mouseCursor,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.helpText,
    this.routeSettings,
    this.strutStyle,
    this.selectableDayPredicate,
    this.anchorPoint,
    this.onEntryModeChanged,
  }) : super(
    builder: (FormFieldState<DateTime?> field) {
      final state = field as _BirthdayPickerState;
      final input = TextField(
        textDirection: textDirection,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        maxLength: maxLength,
        autofocus: autofocus,
        decoration: state.decoration.copyWith(
          hintStyle: '' != field._textFieldController.text ? const TextStyle(color: Colors.transparent) : state.decoration.hintStyle
        ),
        readOnly: true,
        enabled: state.enabled,
        autocorrect: autocorrect,
        focusNode: state.effectiveFocusNode,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        maxLines: maxLines,
        obscureText: obscureText,
        showCursor: showCursor,
        minLines: minLines,
        expands: expands,
        style: style,
        onEditingComplete: onEditingComplete,
        buildCounter: buildCounter,
        mouseCursor: mouseCursor,
        cursorColor: cursorColor,
        cursorRadius: cursorRadius,
        cursorWidth: cursorWidth,
        enableInteractiveSelection: enableInteractiveSelection,
        keyboardAppearance: keyboardAppearance,
        scrollPadding: scrollPadding,
        strutStyle: strutStyle,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        maxLengthEnforcement: maxLengthEnforcement,
      );

      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          input,

          Positioned(
            bottom: 10,
            child: GestureDetector(
              onTap: () => state._showPicker(),

              child: Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,

                
              ),
            ),
          )
        ],
      );
    },
  );

  @override
  FormBuilderFieldDecorationState<BirthdayPicker, DateTime>
  createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends FormBuilderFieldDecorationState<BirthdayPicker, DateTime> {
  late TextEditingController _textFieldController;

  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _textFieldController = widget.controller ?? TextEditingController();
    _dateFormat = widget.format ?? _getDefaultDateTimeFormat();
    //setting this to value instead of initialValue here is OK since we handle initial value in the parent class
    final initVal = value;
    _textFieldController.text =
    initVal == null ? '' : _dateFormat.format(initVal);
    effectiveFocusNode.addListener(_handleFocus);
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_handleFocus);
    // Dispose the _textFieldController when initState created it
    if (null == widget.controller) {
      _textFieldController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleFocus() async {
    if (effectiveFocusNode.hasFocus && enabled) {
      effectiveFocusNode.unfocus();
      await onShowPicker(context, value);
    }
  }

  Future<void> _showPicker() async {
    await onShowPicker(context, value);
  }

  DateFormat _getDefaultDateTimeFormat() => DateFormat(widget.locale?.languageCode);

  Future<DateTime?> onShowPicker(BuildContext context, DateTime? currentValue) async {
    currentValue = value;
    DateTime? newValue = await _showDatePicker(context, currentValue);

    if (!mounted) return null;

    final finalValue = newValue ?? currentValue;

    didChange(finalValue);

    return finalValue;
  }

  Future<DateTime?> _showDatePicker(BuildContext context, DateTime? currentValue) {
    return showDatePicker(
      context: context,
      selectableDayPredicate: widget.selectableDayPredicate,
      initialDatePickerMode: widget.initialDatePickerMode,
      initialDate: currentValue ?? widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      locale: widget.locale,
      textDirection: widget.textDirection,
      useRootNavigator: widget.useRootNavigator,
      builder: widget.transitionBuilder,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      errorFormatText: widget.errorFormatText,
      errorInvalidText: widget.errorInvalidText,
      fieldHintText: widget.fieldHintText,
      fieldLabelText: widget.fieldLabelText,
      helpText: widget.helpText,
      initialEntryMode: widget.initialEntryMode,
      routeSettings: widget.routeSettings,
      currentDate: widget.currentDate,
      anchorPoint: widget.anchorPoint,
      keyboardType: widget.keyboardType,
    );
  }


  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  DateTime combine(DateTime date, TimeOfDay? time) => DateTime(
      date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);

  DateTime? convert(TimeOfDay? time) =>
      time == null ? null : DateTime(1, 1, 1, time.hour, time.minute);

  @override
  void didChange(DateTime? value) {
    super.didChange(value);

    _textFieldController.text = (value == null) ? '' : _dateFormat.format(value);
  }
}
