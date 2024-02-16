import 'package:flickfinder/bootstrap.dart';
import 'package:flickfinder/core/common/config_service.dart';
import 'package:flickfinder/core/common/homepagestateprovider.dart';
import 'package:flickfinder/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flickfinder/injection_container.dart' as di;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigService.initialize();
  await di.init();
  bootstrap(() => const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeState(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flick Finder',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black, // Set icon color inside app bar to black
              ),
              titleTextStyle: TextStyle(
                  color: Colors.black, fontSize: 21) // Change app bar color
              ),
          textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(fontSize: 16),
              labelMedium: TextStyle(color: Colors.white)),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.purple, // Change this color to your desired color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              foregroundColor: Colors.white,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.black)),
                  foregroundColor: Colors.black)),
          primaryColor: Colors.purple,
          primarySwatch: Colors.purple,
        ),
        home: const Homepage(),
      ),
    );
  }
}
