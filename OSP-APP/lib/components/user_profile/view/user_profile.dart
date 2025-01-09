import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fox_core/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:fox_core/components/user_profile/models/user_profile.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/enums/statuses.dart';
import 'package:fox_core/core/helpers.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:fox_core/core/routes.dart';
import 'package:fox_core/shared/custom_input_decoration.dart';
import 'package:fox_core/widgets/circular_image_uploader.dart';
import 'package:fox_core/widgets/circular_loader.dart';
import 'package:fox_core/widgets/circular_loader_with_overlay.dart';
import 'package:fox_core/widgets/form/loader_text.dart';
import 'package:fox_core/widgets/skeleton.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UserProfile extends StatefulWidget {
  final bool isEditMode;
  const UserProfile({super.key, required this.isEditMode});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  static final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _nameFocusNode = FocusNode();
  final UserRepository _userRepository = GetIt.instance<UserRepository>();
  final List<String> _requiredFields = ['name'];

  bool _canGo = false;

  @override
  void initState() {
    _canGo = '' != _userRepository.profile.name;
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();

    super.dispose();
  }

  void _formChangeCallback() {
    int checksum = 0;
    for (String field in _requiredFields) {
      if (!Helpers.fieldHasContent(_formKey.currentState?.fields[field]?.value)) {
        continue;
      }
      checksum++;
    }
    EasyDebounce.debounce(
        'userprofile-debounce',
        const Duration(milliseconds: 256),
        () => setState(() =>
            _canGo = checksum == _requiredFields.length && _formKey.currentState!.validate()));
  }

  Widget _resolveHeadline(BuildContext context, UserProfileState state) {
    List<Widget> children = [];
    children = [
      Text(
        'userProfile.header'.tr(),
        style: CoreTheme.get().textTheme.displayMedium!.copyWith(
              color: CoreColors.primary,
              fontVariations: CoreTheme.semiBlackTextStyle.fontVariations,
              fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! + 2,
            ),
      ),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget _form(BuildContext context, UserProfileState state) {
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
          FormBuilderField(
            name: 'photo',
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<dynamic> field) {
              return InputDecorator(
                decoration: InputDecoration(
                  errorBorder: AppLook.disabledBorder(),
                  border: AppLook.disabledBorder(),
                  focusedBorder: AppLook.disabledBorder(),
                  enabledBorder: AppLook.disabledBorder(),
                  disabledBorder: AppLook.disabledBorder(),
                  contentPadding: const EdgeInsets.all(0),
                ),
                child: const Wrap(),
              );
            },
          ),
          FormBuilderTextField(
            name: 'name',
            initialValue: _userRepository.profile.name,
            focusNode: _nameFocusNode,
            cursorWidth: 1,
            cursorErrorColor: CoreColors.primary,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontVariations: CoreTheme.mediumTextStyle.fontVariations,
                  fontWeight: FontWeight.bold,
                  color: CoreColors.primary,
                ),
            decoration: customInputDecoration().copyWith(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Image.asset('assets/profile/hand.png'),
              ),
              hintText: 'userProfile.form.name_hint'.tr(),
              hintStyle: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: CoreColors.primary.withOpacity(0.6)),
              border: inputEnabledBorder,
              enabledBorder: inputEnabledBorder,
              focusedBorder: inputEnabledBorder,
              focusedErrorBorder: inputEnabledBorder,
            ),
            cursorColor: CoreColors.black,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'userProfile.form.errors.required'.tr()),
              FormBuilderValidators.minLength(1),
              FormBuilderValidators.maxLength(255),
            ]),
            onChanged: (_) => _formChangeCallback(),
          ),
        ],
      ),
    );
  }

  String? _maybeGetProfilePhoto() {
    if (!Uri.parse(_userRepository.profile.profilePicture).isAbsolute) {
      return null;
    }

    return _userRepository.profile.profilePicture;
  }

  void _profilePhotoOnChange(XFile file) async {
    File photo = File(file.path);
    _formKey.currentState?.fields['photo']?.didChange(photo.path);
  }

  void _submitForm(UserProfileState state, BuildContext context) async {
    if (false == (_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }

    String name = _formKey.currentState?.fields['name']?.value ?? '';
    String profilePicture = _formKey.currentState?.fields['photo']?.value ?? '';

    List<T> getModelDataFromForm<T>(String field) {
      List<T> data = _formKey.currentState?.fields[field]?.value ?? [];
      return data.isEmpty ? [] : data;
    }

    UserProfileModel userProfile = UserProfileModel(profilePicture: profilePicture, name: name);

    context.read<UserProfileBloc>().add(MaybeSaveData(userProfile: userProfile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
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
        return Skeleton(
          disableSafeAreaTop: true,
          removeAppBar: true,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                color: CoreColors.white,
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
                        _resolveHeadline(context, state),
                        const SizedBox(height: 80),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularImageUploader(
                              size: 200,
                              onChange: _profilePhotoOnChange,
                              imageUrl: _maybeGetProfilePhoto(),
                            ),
                          ],
                        ),
                        _form(context, state),
                        const SizedBox(height: 200),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_canGo)
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                                      backgroundColor: WidgetStatePropertyAll(CoreColors.primary),
                                      foregroundColor: WidgetStatePropertyAll(CoreColors.black)),
                                  child: Text('userProfile.form.continue'.tr(),
                                      style: CoreTheme.get().textTheme.headlineMedium!.copyWith(
                                          fontVariations: CoreTheme.boldTextStyle.fontVariations)),
                                  onPressed: () => _submitForm(state, context),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
