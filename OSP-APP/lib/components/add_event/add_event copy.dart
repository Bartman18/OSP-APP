/*import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:osp/components/add_event/bloc/add_event_bloc.dart';
import 'package:osp/components/general_views/home/model/event.dart';
import 'package:osp/core/appearance.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/routes.dart';
import 'package:osp/shared/custom_input_decoration.dart';
import 'package:osp/widgets/circular_loader.dart';
import 'package:osp/widgets/circular_loader_with_overlay.dart';
import 'package:osp/widgets/form/loader_text.dart';


class AddEventButton extends StatefulWidget {
const AddEventButton({super.key});

  @override
  State<AddEventButton> createState() => _AddEventButtonState();
}

class _AddEventButtonState extends State<AddEventButton> {
  static final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    //_canGo = '' != _userRepository.profile.name && ;
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();

    super.dispose();
  }
void _formChangeCallback() {
    int checksum = 0;
    EasyDebounce.debounce(
        'userprofile-debounce',
        const Duration(milliseconds: 256),
        () => setState(() =>
            checksum == _formKey.currentState!.validate()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEventBloc, AddEventState>(
      listenWhen: (previousState, state) => previousState.status != state.status,
      listener: (context, state) {
        if (StateStatus.loading == state.status) {
          Widget Function(dynamic)? widgetBuilder;

          if ('' != state.statusMessage) {
            widgetBuilder = (_) {
              return CircularLoaderWithOverlay(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularLoader(),
                    LoaderText(text: state.statusMessage),
                  ],
                ),
              );
            };
          }

          context.loaderOverlay.show(widgetBuilder: widgetBuilder);
        }

        if (StateStatus.loading != state.status) {
          context.loaderOverlay.hide();
        }

        if (StateStatus.error == state.status) {
          Helpers.showErrorBottomSheet(
            context,
            header: 'errors.generic.header'.tr(),
            description: state.errorMessage,
          );
        }

        if (StateStatus.goToNextScreen == state.status) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
      builder: (context, state) {
    return  ElevatedButton(
          style: ElevatedButton.styleFrom(
            //primary: Colors.red.shade800,
          ),
          onPressed: () => showCreateEventPopup(context, state),
          child: Text('Dodaj Wydarzenie'),
    );
      },
    );
  }

void _submitForm(AddEventState state, BuildContext context) async {
    if (false == (_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }

    String name = _formKey.currentState?.fields['name']?.value ?? '';
    String picture = _formKey.currentState?.fields['photo']?.value ?? '';
    DateTime expirationDate = _formKey.currentState?.fields['date']?.value ?? '';
    String description = _formKey.currentState?.fields['description']?.value ?? '';


    List<T> getModelDataFromForm<T>(String field) {
      List<T> data = _formKey.currentState?.fields[field]?.value ?? [];
      return data.isEmpty ? [] : data;
    }

    

    AddEventModel event = AddEventModel(
      name: name,
      expirationDate: expirationDate,
      description: description, 
      categoryId: 1,
      );

    context.read<AddEventBloc>().add(MaybeSaveData(addEvent: event));
  }

  void showCreateEventPopup(BuildContext context, AddEventState state) {
    InputBorder inputEnabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: CoreColors.primary, width: 2),
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          
          //nazwa
          FormBuilderTextField(
            name: 'name',
            focusNode: _nameFocusNode,
            cursorWidth: 1,
            cursorErrorColor: CoreColors.primary,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontVariations: CoreTheme.mediumTextStyle.fontVariations,
                  fontWeight: FontWeight.bold,
                  color: CoreColors.black,
                ),
            decoration: customInputDecoration().copyWith(
              hintText: 'Tytuł wydarzenia',
              hintStyle: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: CoreColors.black.withOpacity(0.8)),
              border: inputEnabledBorder,
              enabledBorder: inputEnabledBorder,
              focusedBorder: inputEnabledBorder,
              focusedErrorBorder: inputEnabledBorder,
            ),
            cursorColor: CoreColors.black,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'add_product.form.errors.required'.tr()),
              FormBuilderValidators.minLength(1),
              FormBuilderValidators.maxLength(255),
            ]),
            onChanged: (_) => _formChangeCallback(),
          ),
            SizedBox(height: 5,),
          //termin
          FormBuilderDateTimePicker(
            name: "date",
            inputType: InputType.date,
            format: DateFormat('dd/MM/yyyy'),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontVariations: CoreTheme.mediumTextStyle.fontVariations,
                  fontWeight: FontWeight.bold,
                  color: CoreColors.black,
                ),
            decoration: customInputDecoration().copyWith(
              hintText: 'Data',
              hintStyle: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: CoreColors.black.withOpacity(0.8)),
              border: inputEnabledBorder,
              enabledBorder: inputEnabledBorder,
              focusedBorder: inputEnabledBorder,
              focusedErrorBorder: inputEnabledBorder,
            ),
            cursorColor: CoreColors.black,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'add_product.form.errors.required'.tr()),
            ]),
            onChanged: (_) => _formChangeCallback(),
            ),
            SizedBox(height: 5,),
          //miejsce
          FormBuilderTextField(
            name: 'place',
            cursorWidth: 1,
            cursorErrorColor: CoreColors.primary,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontVariations: CoreTheme.mediumTextStyle.fontVariations,
                  fontWeight: FontWeight.bold,
                  color: CoreColors.black,
                ),
            decoration: customInputDecoration().copyWith(
              hintText: 'Miejsce',
              hintStyle: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: CoreColors.black.withOpacity(0.8)),
              border: inputEnabledBorder,
              enabledBorder: inputEnabledBorder,
              focusedBorder: inputEnabledBorder,
              focusedErrorBorder: inputEnabledBorder,
            ),
            cursorColor: CoreColors.black,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'add_product.form.errors.required'.tr()),
              FormBuilderValidators.minLength(1),
              FormBuilderValidators.maxLength(255),
            ]),
            onChanged: (_) => _formChangeCallback(),
          ),
            SizedBox(height: 5,),
          //limit
          FormBuilderSlider(
            name: 'number',
            initialValue: 1,
            min: 1,
            max: 50,
            divisions: 49,
            label: 'Limit osób',
            decoration: customInputDecoration().copyWith(
              hintText: 'Limit osób',
              hintStyle: CoreTheme.baseTextStyle.copyWith(
                color: CoreColors.black
              ),
              border: inputEnabledBorder,
              enabledBorder: inputEnabledBorder,
              focusedBorder: inputEnabledBorder,
              focusedErrorBorder: inputEnabledBorder,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'add_product.form.errors.required'.tr()),
              FormBuilderValidators.minLength(1),
              FormBuilderValidators.maxLength(255),
            ]),
            onChanged: (_) => _formChangeCallback(),
          ),
            SizedBox(height: 5,),
          //opis
          FormBuilderTextField(
            name: "description",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontVariations: CoreTheme.mediumTextStyle.fontVariations,
                  fontWeight: FontWeight.bold,
                  color: CoreColors.primary,
                ),
            decoration: customInputDecoration().copyWith(
              hintText: 'Opis',
              hintStyle: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: CoreColors.black.withOpacity(0.8)),
              border: inputEnabledBorder,
              enabledBorder: inputEnabledBorder,
              focusedBorder: inputEnabledBorder,
              focusedErrorBorder: inputEnabledBorder,
            ),
            maxLines: 5,
            cursorColor: CoreColors.black,
            onChanged: (_) => _formChangeCallback(),
            ),
            SizedBox(height: 5,),
            /*ElevatedButton(
                                  style: ButtonStyle(
                                      minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                                      backgroundColor: WidgetStatePropertyAll(CoreColors.primary),
                                      foregroundColor: WidgetStatePropertyAll(CoreColors.black)),
                                  child: Text('add_product.form.save'.tr(),
                                      style: CoreTheme.get().textTheme.headlineMedium!.copyWith(
                                          fontVariations: CoreTheme.boldTextStyle.fontVariations,
                                          color: CoreColors.white,
                                          )),
                                  onPressed: () => _submitForm(state, context),
                                ),*/
        ],
      ),
    ),
          ),
        );
      },
    );
  }
}*/