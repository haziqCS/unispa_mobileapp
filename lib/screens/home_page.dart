import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unispa_mobileapp/components/appointment_card.dart';
import 'package:unispa_mobileapp/components/doctor_card.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> medCat = [
    {"icon": FontAwesomeIcons.userDoctor, "category": "General"},
    {"icon": FontAwesomeIcons.userDoctor, "category": "Category2"},
    {"icon": FontAwesomeIcons.userDoctor, "category": "Category3"},
    {"icon": FontAwesomeIcons.userDoctor, "category": "Category4"},
    {"icon": FontAwesomeIcons.userDoctor, "category": "Category5"},
    {"icon": FontAwesomeIcons.userDoctor, "category": "Category6"},
    {"icon": FontAwesomeIcons.userDoctor, "category": "Category7"},
  ];
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text(
                      'Amanda', //Hard Coded Name
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          'assets/profile1.jpg',
                        ), //Insert image here
                      ),
                    ),
                  ],
                ),
                Config.spaceMedium,
                //Category listing
                const Text(
                  'Category',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Config.spaceSmall,
                //Category List
                SizedBox(
                  height: Config.heightSize * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(medCat.length, (index) {
                      return Card(
                        margin: const EdgeInsets.only(right: 20),
                        color: Config.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FaIcon(
                                medCat[index]['icon'],
                                color: Colors.white,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                medCat[index]['category'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Config.spaceSmall,
                const Text(
                  'Appointment Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Config.spaceSmall,
                AppointmentCard(),
                Config.spaceSmall,
                const Text(
                  'Most Popular Packages',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Config.spaceSmall,
                Column(
                  children: List.generate(10, (index) {
                    return DoctorCard(route: 'doc_details');
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
