import 'package:flutter/material.dart';
import 'package:flutter_user_profile_app/user_shared_preferences.dart';

///
import '../view/home.dart';
import '../view/moblie_body.dart';
import '../view/web_body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter User Profile App UI',
      theme: ThemeData(
          textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        displayMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w300,
          color: Colors.grey,
        ),
        displaySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: Colors.grey,
        ),
      )),
      home: const Home(
        mobile: MobileBody(),
        web: WebBody(),
      ),
    );
  }
}
