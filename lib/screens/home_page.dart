import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unispa_mobileapp/components/appointment_card.dart';
import 'package:unispa_mobileapp/utils/config.dart';

import 'package:unispa_mobileapp/components/package_card.dart'; // ✅
import 'package:unispa_mobileapp/services/api_service.dart'; //

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  Future<Map<String, dynamic>>? _packagesFuture;

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _packagesFuture = apiService.fetchPackages();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _packagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final packages = snapshot.data!;
                  final categories = packages.keys.toList();

                  // Get packages to display based on selected category
                  final List items;
                  if (selectedCategory != null) {
                    items = packages[selectedCategory] ?? [];
                  } else {
                    // Show top few from all categories if none selected
                    items = packages.entries
                        .expand((entry) => entry.value as List)
                        .take(5)
                        .toList();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Amanda',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('profile');
                            },
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                'assets/profile1.jpg',
                              ),
                            ),
                          ),
                        ],
                      ),

                      Config.spaceMedium,

                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,

                      // CATEGORY BUTTONS
                      SizedBox(
                        height: Config.heightSize * 0.05,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            final isSelected = cat == selectedCategory;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedCategory = null; // toggle off
                                  } else {
                                    selectedCategory = cat; // select new
                                  }
                                });
                              },
                              child: Card(
                                margin: const EdgeInsets.only(right: 12),
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Config.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.spa,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        cat,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Config.spaceSmall,

                      const Text(
                        'Appointment Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Config.spaceSmall,

                      AppointmentCard(),

                      Config.spaceSmall,

                      Text(
                        selectedCategory != null
                            ? 'Packages: $selectedCategory'
                            : 'Most Popular Packages',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Config.spaceSmall,

                      Column(
                        children: items.map<Widget>((item) {
                          final option = item['options'][0];
                          return PackageCard(
                            name: item['package_name'],
                            desc: item['package_desc'],
                            price: option['package_price'],
                            duration: option['duration'],
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                'package_details',
                                arguments: {
                                  'name': item['package_name'],
                                  'desc': item['package_desc'],
                                  'price': option['package_price'],
                                  'duration': option['duration'],
                                  'options': item['options'],
                                },
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
