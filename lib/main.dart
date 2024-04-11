import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/news_card.dart';
import 'package:damm_2024/widgets/cells/cards/volunteering_card.dart';
import 'package:damm_2024/widgets/molecules/components/buttons/register_cta_button.dart';
import 'package:damm_2024/widgets/molecules/components/vacancies_chip.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'widgets/tokens/fonts.dart';
import 'widgets/tokens/colors.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
          body: const TabBarView(
            children: [
              Center(child: Text('Contenido de Postularse')),
              Center(child: Text('Contenido de Mi Perfil')),
              Center(child: Text('Contenido de Novedades')),
            ],
          ),
        ),
      ),
    );
  }
}