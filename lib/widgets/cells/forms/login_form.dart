import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  static const route = "/login";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volunteer = ref.watch(volunteerProvider);
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
                          onPressed: () => context.go('/apply'),
                          filled: true,
                          actionStr: 'Iniciar Sesión'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: CtaButton(
                          enabled: true,
                          onPressed: () => context.go('/register'),
                          filled: false,
                          actionStr: 'No tengo cuenta'),
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