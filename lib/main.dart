import 'package:flutter/material.dart';
import 'package:app_news/pages/on_boarding_page.dart';
import 'package:app_news/providers/nasional_news_provider.dart';
import 'package:app_news/providers/news_update_provider.dart';
import 'package:app_news/providers/tech_news_provider.dart';
import 'package:app_news/providers/ekonomi_news_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart' as intl;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await intl.initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NewsUpdateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TechNewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EkonomiNewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NasionalNewsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const OnBoardingPage(),
      ),
    );
  }
}