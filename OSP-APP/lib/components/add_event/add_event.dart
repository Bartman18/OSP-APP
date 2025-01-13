import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:osp/components/add_event/model/add_event_model.dart';
import 'package:osp/components/add_event/bloc/add_event_bloc.dart';
import 'package:osp/core/appearance.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/repositories/settings.dart';
import 'package:osp/core/repositories/user.dart';
import 'package:osp/core/routes.dart';
import 'package:osp/shared/custom_input_decoration.dart';
import 'package:osp/shared/models/products_api_models.dart';
import 'package:osp/widgets/circular_loader.dart';
import 'package:osp/widgets/circular_loader_with_overlay.dart';
import 'package:osp/widgets/form/loader_text.dart';
import 'package:osp/widgets/skeleton.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddEventView extends StatelessWidget {
 AddEventView({super.key});

  
static final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _nameFocusNode = FocusNode();
  //final UserRepository _userRepository = GetIt.instance<UserRepository>();
  final List<String> _requiredFields = ['name', 'date', 'category'];

  Widget _resolveHeadline(BuildContext context) {
    List<Widget> children = [];
    children = [
      BackButton(
        onPressed: () {Navigator.pushReplacementNamed(context, Routes.home); },
        color: CoreColors.black,
      ),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

Widget _form(BuildContext context) {

    InputBorder inputEnabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: CoreColors.primary, width: 2),
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
    );

    return FormBuilder(
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
            ),
        ],
      ),
    );
  }


  void _submitForm(BuildContext context) async {
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
      description: description, categoryId: 1,
      );

    context.read<AddEventBloc>().add(MaybeSaveData(addEvent: event));
  }

  @override
  Widget build(BuildContext context) {
        return Dialog( 
          backgroundColor: CoreColors.primary,
        child: Skeleton(
          disableSafeAreaTop: true,
          removeAppBar: true,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                color: CoreColors.primary,
              ),
              SafeArea(
                top: true,
                bottom: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        _resolveHeadline(context),
                        const SizedBox(height: 80),
                        
                        _form(context),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                  style: ButtonStyle(
                                      minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                                      backgroundColor: WidgetStatePropertyAll(CoreColors.primary),
                                      foregroundColor: WidgetStatePropertyAll(CoreColors.black)),
                                  child: Text('Dodaj',
                                      style: CoreTheme.get().textTheme.headlineMedium!.copyWith(
                                          fontVariations: CoreTheme.boldTextStyle.fontVariations,
                                          color: CoreColors.white,
                                          )),
                                  onPressed: () => _submitForm(context),
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        );
      }
}