import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/screens/profile_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/news_card.dart';
import 'package:damm_2024/widgets/cells/cards/volunteering_card.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
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
          body: TabBarView(
            children: [
              Center(child: Text('Contenido de Postularse')),
              ProfileScreen(volunteer: 
                Volunteer(
                  firstName: 'Juan',
                  lastName: 'Perez',
                  profileImageURL: 'https://s3-alpha-sig.figma.com/img/113f/a25a/235312cc53dcd4c8780648145d59e3c2?Expires=1713744000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=P7~GspZy9w~6SVCZ46rykZx1vy8LmL02Qgb9uYkF0xmXvaox4jycbD9TYotWVsyCfwZTmtOgShzz5KWFOgTgeX-fjJBBgnWonGmTmBMFdpAPPNDLvZSbyt3ZlfEv7FjZPr-Lr-Hm2UpcChqFA4iThql1IDJQn88cPT2P46S-oyF~3N4JN-jsm8xFC-ZBqmHZFIxtwJ7hXP2ggV5gcNiF3CDW~kpRPaV8le8yTD2-6SCpgaw1smhXoeSUkstVXe231pLc4HWH0QqMIIKtUw2GL~jEmQzVuXPhluD-jon22xVW5nsl4Tk8vnlS-U63vMeydvMJj9EuxYTu3-dfxoYMRw__',
                  email: 'email@email.com',
                  phoneNumber: '+5491165863216',
                  dateOfBirth: DateTime.now(),
                  gender: 'Masculino',
                )
              ),
              Center(child: Text('Contenido de Novedades')),
            ],
          ),
        ),
      ),
    );
  }
}