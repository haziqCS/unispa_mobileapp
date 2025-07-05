import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/services/api_service.dart';
import 'package:unispa_mobileapp/components/package_card.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>>? _packagesFuture;

  //List<Map<String, dynamic>> _packages = [];
  //List<Map<String, dynamic>> _filteredPackages = [];
  //List<String> _categories = [];
  String? _selectedCategory = 'ALL'; // <- Always have initial value
  //String? _error;

  @override
  void initState() {
    super.initState();
    _packagesFuture = _apiService.fetchPackages();
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _packagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No packages found'));
              }

              final packagesData = snapshot.data!;
              final categories = packagesData.keys.toList();

              // If there was no category selected, default to first
              if (_selectedCategory == 'ALL' && categories.isNotEmpty) {
                _selectedCategory = 'ALL';
              }

              // Which packages to show
              final List packagesToShow = _selectedCategory == 'ALL'
                  ? packagesData.entries
                      .expand((entry) => entry.value as List)
                      .toList()
                  : (packagesData[_selectedCategory] ?? []);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Packages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Filter chips
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: const Text('All'),
                              selected: _selectedCategory == 'ALL',
                              onSelected: (_) => _selectCategory('ALL'),
                              selectedColor: Config.primaryColor,
                            ),
                          );
                        }

                        final category = categories[index - 1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (_) => _selectCategory(category),
                            selectedColor: Config.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: packagesToShow.isEmpty
                        ? const Center(child: Text('No packages in this category'))
                        : ListView.builder(
                            itemCount: packagesToShow.length,
                            itemBuilder: (context, index) {
                              final package = packagesToShow[index];
                              final name = package['package_name'] ?? 'No Name';
                              final desc = package['description'] ?? package['package_desc'] ?? '';
                              final options = package['options'] ?? [];

                              final option = options.isNotEmpty
                                  ? options[0]
                                  : {
                                      'package_price': 'N/A',
                                      'duration': 'N/A',
                                      'capacity': 'N/A',
                                    };

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    'package_details',
                                    arguments: {
                                      'name': name,
                                      'desc': desc,
                                      'options': options,
                                    },
                                  );
                                },
                                child: PackageCard(
                                  name: name,
                                  desc: desc,
                                  price: option['package_price'],
                                  duration: option['duration'],
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      'package_details',
                                      arguments: {
                                        'name': name,
                                        'desc': desc,
                                        'options': options,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}