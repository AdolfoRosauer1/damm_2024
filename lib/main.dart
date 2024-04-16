import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/screens/profile_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/news_card.dart';
import 'package:damm_2024/widgets/cells/cards/volunteering_card.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/molecules/components/vacancies_chip.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/tokens/fonts.dart';
import 'widgets/tokens/colors.dart';

void main() {

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          overlayColor: MaterialStateProperty.all(ProjectPalette.neutral2.withOpacity(0.1)),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 3.0, color:ProjectPalette.neutral1)),
            color: ProjectPalette.secondary6
          ),
          labelColor: ProjectPalette.neutral1,
          unselectedLabelColor: ProjectPalette.neutral4,
        ),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ProjectPalette.secondary5,
            title: Image.asset('lib/widgets/atoms/logo_rectangular.png'),
            bottom: const TabBar(
           //   dividerColor: ProjectPalette.neutral3,
            //  dividerHeight: 30,
              tabs: [
                Tab(text: 'Postularse'),
                Tab(text: 'Mi perfil'),
                Tab(text: 'Novedades'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text('Contenido de Postularse')),
              ProfileScreen(),
              Center(child: Text('Contenido de Novedades')),
            ],
          ),
        ),
      ),
    );
  }
}