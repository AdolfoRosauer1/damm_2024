import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:damm_2024/providers/auth_provider.dart';
import 'package:damm_2024/providers/connectivity_provider.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
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

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  static const route = "/login";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends ConsumerState<LoginForm> {
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
    final internetStatus = ref.watch(internetConnectionProvider);
    final internet = internetStatus.value! == InternetStatus.connected;

    final authController = ref.watch(authControllerProvider);

    return Theme(
      data: ThemeData(
          appBarTheme: const AppBarTheme(color: ProjectPalette.neutral1)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo_cuadrado.png'),
                      const SizedBox(
                        height: 16,
                      ),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        name: 'email',
                        onChanged: (_) => onFormChanged(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ProjectPalette.neutral6),
                              borderRadius: BorderRadius.circular(4)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: const Text('Email'),
                          labelStyle: ProjectFonts.caption.copyWith(
                              color: ProjectPalette.neutral6,
                              backgroundColor: ProjectPalette.neutral3),
                          hintText: 'Ej: juanbarcena@mail.com',
                          hintStyle: ProjectFonts.subtitle1
                              .copyWith(color: ProjectPalette.neutral5),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (_) => onFormChanged(),
                        name: 'password',
                        obscureText: _hidePassword,
                        keyboardType: TextInputType.visiblePassword,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required()
                        ]),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ProjectPalette.neutral6),
                              borderRadius: BorderRadius.circular(4)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: _hidePassword
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: ProjectIcons.visibilityFilledEnabled)
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon:
                                      ProjectIcons.visibilityOffFilledEnabled),
                          suffixIconColor: ProjectPalette.neutral6,
                          label: Text(AppLocalizations.of(context)!
                              .password), 
                          labelStyle: ProjectFonts.caption.copyWith(
                              color: ProjectPalette.neutral6,
                              backgroundColor: ProjectPalette.neutral3),
                          hintText: 'Ej: ABCD1234',
                          hintStyle: ProjectFonts.subtitle1
                              .copyWith(color: ProjectPalette.neutral5),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: ValueListenableBuilder(
                            valueListenable: formValid,
                            builder: (context, formValid, child) {
                              return isLoading
                                  ? const CircularProgressIndicator()
                                  : CtaButton(
                                      enabled: formValid,
                                      actionStr:
                                          AppLocalizations.of(context)!.login,
                                      filled: true,
                                      onPressed: () async {
                                        if (!formValid) {
                                          return;
                                        }
                                        if (!internet) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const NoInternetModal();
                                              });
                                          return;
                                        }
                                        if (formKey.currentState
                                                ?.saveAndValidate() ??
                                            false) {
                                          final formValues =
                                              formKey.currentState?.value;
                                          final email = formValues?['email'];
                                          final password =
                                              formValues?['password'];

                                          try {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await authController.signOut();
                                            User? user = await authController
                                                .signInWithEmailAndPassword(
                                              email,
                                              password,
                                            );
                                            if (user != null) {
                                              if (context.mounted) {
                                                context.go('/apply');
                                              }
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code == "user-not-found" ||
                                                e.code == "wrong-password" ||
                                                e.code ==
                                                    "invalid-credential") {
                                              if (context.mounted){
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    content:
                                                    AwesomeSnackbarContent(
                                                      title: "Error",
                                                      message:
                                                      AppLocalizations.of(
                                                          context)!
                                                          .error_noUser,
                                                      contentType:
                                                      ContentType.failure,
                                                    )));
                                              }

                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    content:
                                                        AwesomeSnackbarContent(
                                                      title: "Error",
                                                      message:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .error_generic,
                                                      contentType:
                                                          ContentType.failure,
                                                    )));
                                            }
                                          } finally {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        }
                                      });
                            })),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: CtaButton(
                          enabled: true,
                          onPressed: () => context.go('/register'),
                          filled: false,
                          actionStr: AppLocalizations.of(context)!.noAccount),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
