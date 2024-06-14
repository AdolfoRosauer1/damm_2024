import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:damm_2024/providers/auth_provider.dart';
import 'package:damm_2024/providers/connectivity_provider.dart';
import 'package:damm_2024/screens/apply_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/forms/login_form.dart';
import 'package:damm_2024/widgets/cells/modals/no_internet_modal.dart';
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
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  static const route = "/register";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final formKey = GlobalKey<FormBuilderState>();
  final ValueNotifier formValid = ValueNotifier<bool>(false);
  bool isLoading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    formValid.dispose();
    super.dispose();
  }

  void onFormChanged() {
    formValid.value = formKey.currentState!.validate(focusOnInvalid: false);
 
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final internetStatus = ref.watch(internetConnectionProvider);
    final internet = internetStatus.value! == InternetStatus.connected;

    return Theme(
      data: ThemeData(
        appBarTheme: const AppBarTheme(color: ProjectPalette.neutral1),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 31),
              Image.asset('assets/images/logo_cuadrado.png'),
              const SizedBox(height: 16),
              FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'name',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.match(r'^[a-zA-Z ]+$')
                      ]),
                      onChanged: (_) => onFormChanged(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ProjectPalette.neutral6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.name),
                        labelStyle: ProjectFonts.caption.copyWith(
                          color: ProjectPalette.neutral6,
                          backgroundColor: ProjectPalette.neutral3,
                        ),
                        hintText: 'Ej: Juan',
                        hintStyle: ProjectFonts.subtitle1
                            .copyWith(color: ProjectPalette.neutral5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FormBuilderTextField(
                      name: 'lastname',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.match(r'^[a-zA-Z ]+$')
                      ]),
                      onChanged: (_) => onFormChanged(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ProjectPalette.neutral6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.lastname),
                        labelStyle: ProjectFonts.caption.copyWith(
                          color: ProjectPalette.neutral6,
                          backgroundColor: ProjectPalette.neutral3,
                        ),
                        hintText: 'Ej: Barcena',
                        hintStyle: ProjectFonts.subtitle1
                            .copyWith(color: ProjectPalette.neutral5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FormBuilderTextField(
                      name: 'email',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email()
                      ]),
                      onChanged: (_) => onFormChanged(),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ProjectPalette.neutral6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: const Text('Email'),
                        labelStyle: ProjectFonts.caption.copyWith(
                          color: ProjectPalette.neutral6,
                          backgroundColor: ProjectPalette.neutral3,
                        ),
                        hintText: 'Ej: juanbarcena@mail.com',
                        hintStyle: ProjectFonts.subtitle1
                            .copyWith(color: ProjectPalette.neutral5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FormBuilderTextField(
                      name: 'password',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      onChanged: (_) => onFormChanged(),
                      obscureText: _hidePassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ProjectPalette.neutral6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          icon: _hidePassword
                              ? ProjectIcons.visibilityFilledEnabled
                              : ProjectIcons.visibilityOffFilledEnabled,
                        ),
                        suffixIconColor: ProjectPalette.neutral6,
                        label: Text(AppLocalizations.of(context)!.password),
                        labelStyle: ProjectFonts.caption.copyWith(
                          color: ProjectPalette.neutral6,
                          backgroundColor: ProjectPalette.neutral3,
                        ),
                        hintText: 'Ej: ABCD1234',
                        hintStyle: ProjectFonts.subtitle1
                            .copyWith(color: ProjectPalette.neutral5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 104),
              ValueListenableBuilder(
                valueListenable: formValid,
                builder: (context, formValid, child) {
                  return isLoading
                      ? const CircularProgressIndicator()
                      : CtaButton(
                          enabled: formValid,
                          onPressed: () async {
                            if (!formValid) {
                              return;
                            }
                            if (!internet) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const NoInternetModal();
                                },
                              );
                              return;
                            }
                            if (formKey.currentState?.saveAndValidate() ??
                                false) {
                              final formValues = formKey.currentState?.value;
                              final email = formValues?['email'];
                              final password = formValues?['password'];
                              final name = formValues?['name'];
                              final lastName = formValues?['lastname'];
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                await authController.signOut();
                                await authController.registerUser(
                                    email, password, name, lastName);
                                if (context.mounted) {
                                  context.go(ApplyScreen.route);
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == "email-already-in-use") {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: "Error",
                                        message: AppLocalizations.of(context)!
                                            .error_emailAlreadyExists,
                                        contentType: ContentType.failure,
                                      ),
                                    ));
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: "Error",
                                        message: AppLocalizations.of(context)!
                                            .error_generic,
                                        contentType: ContentType.failure,
                                      ),
                                    ));
                                  }
                                }
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            } 
                          },
                          filled: true,
                          actionStr: AppLocalizations.of(context)!.register,
                        );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: CtaButton(
                  enabled: true,
                  onPressed: () => context.go(LoginForm.route),
                  filled: false,
                  actionStr: AppLocalizations.of(context)!.alreadyHaveAccount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
