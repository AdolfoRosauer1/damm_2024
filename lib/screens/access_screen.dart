import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccessScreen extends StatelessWidget {
  static const route = "/access";

  const AccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/widgets/atoms/logo_cuadrado.png'),
                  const SizedBox(height: 30),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Text(
                      AppLocalizations.of(context)!.quote,
                      style: ProjectFonts.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: CtaButton(
                  enabled: true,
                  onPressed: () => context.go('/login'),
                  filled: true,
                  actionStr: AppLocalizations.of(context)!.login,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: CtaButton(
                  enabled: true,
                  onPressed: () => context.go('/register'),
                  filled: false,
                  actionStr: AppLocalizations.of(context)!.register,
                ),
              ),
              const SizedBox(
                height: 24,
              )
            ],
          ),
        ],
      ),
    );
  }
}
