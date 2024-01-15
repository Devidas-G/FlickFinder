import 'package:flickfinder/core/common/config_service.dart';
import 'package:flickfinder/core/common/homepagestateprovider.dart';
import 'package:flickfinder/features/movie/providers/moviesprovider.dart';
import 'package:flickfinder/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flickfinder/injection_container.dart' as di;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigService.initialize();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeState(),
        ),
        ChangeNotifierProvider(
          create: (context) => MoviesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Number Trivia',
        theme: ThemeData(
          primaryColor: Colors.green.shade800,
        ),
        home: const Homepage(),
      ),
    );
  }
}
