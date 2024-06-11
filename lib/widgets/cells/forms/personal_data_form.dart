import 'package:damm_2024/config/router.dart';
import 'package:damm_2024/models/gender.dart';
import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/providers/auth_provider.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/screens/profile_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/input_card.dart';
import 'package:damm_2024/widgets/cells/cards/profile_picture_card.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PersonalDataForm extends ConsumerStatefulWidget {
  PersonalDataForm({super.key});

  static const route = "editProfile";
  static const completeRoute = "${ProfileScreen.route}/$route";

  @override
  _PersonalDataFormState createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends ConsumerState<PersonalDataForm> {
  final formKey = GlobalKey<FormBuilderState>();
  late ValueNotifier<bool> isFormValidNotifier;
  late ValueNotifier<bool> isLoadingNotifier;
  late Volunteer volunteer;

  @override
  void initState() {
    super.initState();
    Volunteer? aux = ref.read(currentUserProvider);
    volunteer = aux!;
    isFormValidNotifier = ValueNotifier(volunteer.hasCompletedProfile());
    isLoadingNotifier = ValueNotifier(false);
  }

  void onFormChanged() {
    FocusScope.of(context).unfocus();
    isFormValidNotifier.value =
        formKey.currentState!.validate(focusOnInvalid: false);
    final errors = formKey.currentState?.errors;
    if (errors != null) {
      errors.forEach((key, value) {
        print('Error en el campo $key: $value');
      });
    }
  }

  @override
  void dispose() {
    isFormValidNotifier.dispose();
    isLoadingNotifier.dispose();
    super.dispose();
  }

  Map<String, String> genderGenderMap(BuildContext context) {
    Map<String, String> enumMap = {};

    for (var item in Gender.values) {
      enumMap[item.localizedValue(context)] = item.value;
    }

    return enumMap;
  }

  @override
  Widget build(BuildContext context) {
    final profileController = ref.read(profileControllerProvider);
    final User? _firebaseUser =
        ref.read(firebaseAuthenticationProvider).currentUser;
    var genderMap = genderGenderMap(context);
    return Theme(
      data: ThemeData(
          appBarTheme: const AppBarTheme(color: ProjectPalette.neutral1)),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: ProjectPalette.neutral6),
          leading: IconButton(
              onPressed: () => {
                    CustomNavigationHelper.parentNavigatorKey.currentState!
                        .pop()
                  },
              icon: ProjectIcons.closeFilledEnabled),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.profileData,
                          style: ProjectFonts.headline1,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FormBuilderDateTimePicker(
                        name: 'dateOfBirth',
                        initialValue: volunteer.dateOfBirth,
                        validator: FormBuilderValidators.required(),
                        decoration: InputDecoration(
                          suffixIcon: ProjectIcons.calendarFilledActivated,
                          labelStyle: ProjectFonts.caption.copyWith(
                              color: ProjectPalette.neutral6,
                              backgroundColor: ProjectPalette.neutral3),
                          hintText: "DD/MM/YY",
                          hintStyle: ProjectFonts.subtitle1
                              .copyWith(color: ProjectPalette.neutral5),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText:
                              AppLocalizations.of(context)!.dateOfBirthMin,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ProjectPalette.neutral6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        inputType: InputType.date,
                        format: DateFormat('dd/MM/yyyy'),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration:
                            const BoxDecoration(color: ProjectPalette.neutral3),
                        child: FormBuilderField(
                          name: 'gender',
                          initialValue: volunteer.gender?.value,
                          validator: FormBuilderValidators.required(),
                          builder: (FormFieldState<dynamic> field) {
                            return InputCard(
                              title: AppLocalizations.of(context)!
                                  .profileInformation,
                              labels: genderMap.keys.toList(),
                              state: field,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FormBuilderField(
                        name: 'profilePicture',
                        onSaved: (_) => onFormChanged(),
                        validator: FormBuilderValidators.required(),
                        initialValue: volunteer.profileImageURL,
                        builder: (FormFieldState<dynamic> field) {
                          return ProfilePictureCard(
                            imageUrl: volunteer.profileImageURL,
                            field: field,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.contactInformation,
                          style: ProjectFonts.headline1,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        AppLocalizations.of(context)!.contactText,
                        style: ProjectFonts.subtitle1,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FormBuilderTextField(
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.match(r'^\+\d{1,15}$')
                        ]),
                        initialValue: volunteer.phoneNumber,
                        onEditingComplete: onFormChanged,
                        name: 'phoneNumber',
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ProjectPalette.neutral6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text(AppLocalizations.of(context)!.phoneMin),
                          labelStyle: ProjectFonts.caption.copyWith(
                              color: ProjectPalette.neutral6,
                              backgroundColor: ProjectPalette.neutral3),
                          hintText: 'Ej: +541178445459',
                          hintStyle: ProjectFonts.subtitle1
                              .copyWith(color: ProjectPalette.neutral5),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FormBuilderTextField(
                        initialValue: volunteer.email.isEmpty
                            ? _firebaseUser?.email
                            : volunteer.email,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email()
                        ]),
                        name: 'email',
                        onEditingComplete: onFormChanged,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ProjectPalette.neutral6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: const Text('Mail'),
                          labelStyle: ProjectFonts.caption.copyWith(
                              color: ProjectPalette.neutral6,
                              backgroundColor: ProjectPalette.neutral3),
                          hintText: 'Ej: mimail@mail.com',
                          hintStyle: ProjectFonts.subtitle1
                              .copyWith(color: ProjectPalette.neutral5),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ValueListenableBuilder(
                        valueListenable: isFormValidNotifier,
                        builder: (context, valid, child) {
                          return CtaButton(
                            enabled: valid,
                            onPressed: () async {
                              if (!valid) {
                                return;
                              }
                              try {
                                if (formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  final formData = formKey.currentState?.value;
                                  formKey.currentState!.fields['gender']
                                      ?.didChange(genderMap[formKey
                                          .currentState!
                                          .fields['gender']
                                          ?.value]);

                                  print(formData?["gender"]);
                                  print('Form Data: $formData');

                                  var gender = formData?["gender"];
                                  final updatedFormData =
                                      Map<String, dynamic>.from(formData ?? {});
                                  updatedFormData["gender"] = genderMap[gender];
                                  print("----------------");
                                  print(updatedFormData["gender"]);
                                  print('UpdatedForm Data: $updatedFormData');
                                  isLoadingNotifier.value = true;
                                  await profileController
                                      .finishSetup(updatedFormData);
                                  isLoadingNotifier.value = false;
                                  context.go('/profileScreen');
                                } else {
                                  print('Validation failed');
                                }
                              } catch (e) {
                                isLoadingNotifier.value = false;
                                print('Error saving form: $e');
                              }
                            },
                            filled: true,
                            actionStr: AppLocalizations.of(context)!.saveData,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      )
                    ],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, child) {
                if (isLoading) {
                  return Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildRadioOption(
    FormFieldState<dynamic> field, String value, String label) {
  return Theme(
    data: Theme.of(field.context).copyWith(
      radioTheme: Theme.of(field.context).radioTheme.copyWith(
            fillColor: MaterialStateProperty.all(ProjectPalette.primary1),
          ),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Radio<String>(
            value: value,
            groupValue: field.value,
            onChanged: (val) {
              field.didChange(val);
            },
          ),
        ),
        Text(
          label,
          style: ProjectFonts.body1.copyWith(color: ProjectPalette.black),
        ),
      ],
    ),
  );
}
