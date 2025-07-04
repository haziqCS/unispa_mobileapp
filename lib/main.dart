import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/screens/auth_page.dart';
import 'package:unispa_mobileapp/screens/booking_page.dart';
import 'package:unispa_mobileapp/screens/doctor_details.dart';
import 'package:unispa_mobileapp/screens/register_page.dart';
import 'package:unispa_mobileapp/screens/success_booked.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/utils/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //THis is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Define ThemeData here
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Pre-defined Input decoration
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Config.primaryColor,
          border: Config.outlinedBorder,
          focusedBorder: Config.focusBorder,
          errorBorder: Config.errorBorder,
          enabledBorder: Config.outlinedBorder,
          floatingLabelStyle: TextStyle(color: Config.primaryColor),
          prefixIconColor: Colors.black38,
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Config.primaryColor,
          selectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey.shade700,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
        primarySwatch: Colors.blue,
      ),
      //This is the initial route of the app
      //Which is the auth page (login and sign up)
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        'register': (context) => const RegisterPage(),
        //This is for main layout after login
        'main': (context) => const MainLayout(),
        'doc_details': (context) => const DoctorDetails(),
        'booking_page': (context) => const BookingPage(),
        'success_booking': (context) => const AppointmentBooked(),
      },
      //home: const MyHomePage(title: 'UniSpa App'),
    );
  }
}
