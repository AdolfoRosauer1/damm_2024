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
  const PersonalDataForm({super.key});

  static const route = "editProfile";
  static const completeRoute = "${ProfileScreen.route}/$route";

  @override
  PersonalDataFormState createState() => PersonalDataFormState();
}

class PersonalDataFormState extends ConsumerState<PersonalDataForm> {
  // bool _internet = false;
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
    isFormValidNotifier.value =
        formKey.currentState!.validate(focusOnInvalid: false);

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
    // final internetStatus = ref.watch(internetConnectionProvider);
    // _internet = internetStatus.value! == InternetStatus.connected;
    final profileController = ref.read(profileControllerProvider);
    final User? firebaseUser =
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (_) => onFormChanged(),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (_) => onFormChanged(),
                          name: 'gender',
                          initialValue:
                              volunteer.gender?.localizedValue(context),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'profilePicture',
                        onChanged: (_) => onFormChanged(),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.match(r'^\+\d{10,14}$',
                              errorText: AppLocalizations.of(context)!
                                  .error_invalidPhoneFormat)
                        ]),
                        initialValue: volunteer.phoneNumber.isEmpty
                            ? '+'
                            : volunteer.phoneNumber,
                        onChanged: (_) => onFormChanged(),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: volunteer.email.isEmpty
                            ? firebaseUser?.email
                            : volunteer.email,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email()
                        ]),
                        name: 'email',
                        onChanged: (_) => onFormChanged(),
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
                              // if (!_internet) {
                              //   showDialog(
                              //       context: context,
                              //       builder: (context) {
                              //         return const NoInternetModal();
                              //       });
                              //   return;
                              // }
                              try {
                                if (formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  final formData = formKey.currentState?.value;
                                  formKey.currentState!.fields['gender']
                                      ?.didChange(genderMap[formKey
                                          .currentState!
                                          .fields['gender']
                                          ?.value]);

               

                                  var gender = formData?["gender"];
                                  final updatedFormData =
                                      Map<String, dynamic>.from(formData ?? {});
                                  updatedFormData["gender"] = genderMap[gender];
                   
                                  isLoadingNotifier.value = true;
                                  await profileController
                                      .finishSetup(updatedFormData);
                                  isLoadingNotifier.value = false;
                                  if (context.mounted) {
                                    context.go('/profileScreen');
                                  }
                                } 
                              } catch (e) {
                                isLoadingNotifier.value = false;
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

