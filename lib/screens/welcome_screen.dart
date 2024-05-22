import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/widgets/atoms/logo_cuadrado.png'),
            const SizedBox(height: 30),
            Text('¡Bienvenido!', style:ProjectFonts.headline1),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: Text('Nunca subestimes tu habilidad para mejorar la vida de alguien.'
              , style: ProjectFonts.subtitle1,
              textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 146),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CtaButton(
                      enabled: true,
                      onPressed: () => context.go('/apply'), 
                      filled: true, 
                      actionStr: 'Comenzar'),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}