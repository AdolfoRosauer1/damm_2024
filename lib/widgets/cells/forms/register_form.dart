import 'package:damm_2024/providers/auth_provider.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  static const route = "/register";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(firebaseAuthProvider);
    final formKey = GlobalKey<FormBuilderState>();

    return Theme(
      data: ThemeData(
          appBarTheme: const AppBarTheme(color: ProjectPalette.neutral1)),
      child: Scaffold(
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ProjectPalette.neutral6),
                              borderRadius: BorderRadius.circular(4)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: const Text('Nombre'),
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ProjectPalette.neutral6),
                              borderRadius: BorderRadius.circular(4)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: const Text('Apellido'),
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
                          label: const Text('Contraseña'),
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
                      child: CtaButton(
                          enabled: true,
                          onPressed: () async {
                            if (formKey.currentState?.saveAndValidate() ??
                                false) {
                              final formValues = formKey.currentState?.value;
                              final email = formValues?['email'];
                              final password = formValues?['password'];
                              final name = formValues?['name'];
                              final lastName = formValues?['lastname'];
                              try {
                                await authProvider.signOut();
                                await authProvider.registerUser(
                                    email, password, name, lastName);
                                print(authProvider.currentUser);
                                context.go('/apply');
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              print("Validation failed");
                            }
                          },
                          filled: true,
                          actionStr: 'Registrarse'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: CtaButton(
                          enabled: true,
                          onPressed: () => context.go('/login'),
                          filled: false,
                          actionStr: 'Ya tengo cuenta'),
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
