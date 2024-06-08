import 'package:damm_2024/providers/auth_provider.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void dispose() {
    formValid.dispose();
    super.dispose();
  }

  void onFormChanged() {
    print("ON FORM CHANGEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd");
    FocusScope.of(context).unfocus();

    formValid.value = formKey.currentState!.validate(focusOnInvalid: false);
    final errors = formKey.currentState?.errors;
    if (errors != null) {
      errors.forEach((key, value) {
        print('Error en el campo $key: $value');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      Image.asset('lib/widgets/atoms/logo_cuadrado.png'),
                      const SizedBox(
                        height: 16,
                      ),
                      FormBuilderTextField(
                        name: 'name',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.match(r'^[a-zA-Z ]+$')
                        ]),
                        onEditingComplete: onFormChanged,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ProjectPalette.neutral6),
                              borderRadius: BorderRadius.circular(4)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text(AppLocalizations.of(context)!
                              .name), //TEXTO A CAMBIAR
                          labelStyle: ProjectFonts.caption.copyWith(
                              color: ProjectPalette.neutral6,
                              backgroundColor: ProjectPalette.neutral3),
                          hintText: 'Ej: Juan',
                          hintStyle: ProjectFonts.subtitle1
                              .copyWith(color: ProjectPalette.neutral5),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FormBuilderTextField(
                        name: 'lastname',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.match(r'^[a-zA-Z ]+$')
                        ]),
                        onEditingComplete: onFormChanged,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ProjectPalette.neutral6),
                              borderRadius: BorderRadius.circular(4)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text(AppLocalizations.of(context)!
                              .lastname), //TEXTO A CAMBIAR
                          labelStyle: ProjectFonts.caption.copyWith(
                              color: ProjectPalette.neutral6,
                              backgroundColor: ProjectPalette.neutral3),
                          hintText: 'Ej: Barcena',
                          hintStyle: ProjectFonts.subtitle1
                              .copyWith(color: ProjectPalette.neutral5),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FormBuilderTextField(
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email()
                        ]),
                        onEditingComplete: onFormChanged,
                        name: 'email',
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
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                        onEditingComplete: onFormChanged,
                        name: 'password',
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ProjectPalette.neutral6),
                              borderRadius: BorderRadius.circular(4)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: ProjectIcons.visibilityOffFilledEnabled,
                          suffixIconColor: ProjectPalette.neutral6,
                          label: Text(AppLocalizations.of(context)!
                              .password), //TEXTO A CAMBIAR
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
                            return CtaButton(
                              enabled: formValid,
                              onPressed: () async {
                                if (!formValid) {
                                  return;
                                }
                                if (formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  final formValues =
                                      formKey.currentState?.value;
                                  final email = formValues?['email'];
                                  final password = formValues?['password'];
                                  final name = formValues?['name'];
                                  final lastName = formValues?['lastname'];
                                  try {
                                    await authController.signOut();
                                    await authController.registerUser(
                                        email, password, name, lastName);
                                    context.go('/apply');
                                  } catch (e) {
                                    print(e);
                                  }
                                } else {
                                  print("Validation failed");
                                }
                              },
                              filled: true,
                              actionStr: AppLocalizations.of(context)!
                                  .register, //TEXTO A CAMBIAR
                            );
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: CtaButton(
                          enabled: true,
                          onPressed: () => context.go('/login'),
                          filled: false,
                          actionStr: AppLocalizations.of(context)!
                              .alreadyHaveAccount), //TEXTO A CAMBIAR
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
