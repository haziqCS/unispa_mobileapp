import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/screens/admin/add_package_page.dart'; // <-- Make sure you import this!
import 'package:unispa_mobileapp/screens/admin/admin_edit_package.dart'; // <-- Make sure you import this!

class AdminPackagesListPage extends StatefulWidget {
  const AdminPackagesListPage({super.key});

  @override
  State<AdminPackagesListPage> createState() => _AdminPackagesListPageState();
}

class _AdminPackagesListPageState extends State<AdminPackagesListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _searchQuery;

  final List<Map<String, String>> _packages = [
    {
      'id': '1',
      'name': 'Facial Treatment',
      'price': 'RM 120',
      'duration': '60 mins',
    },
    {
      'id': '2',
      'name': 'Full Body Massage',
      'price': 'RM 200',
      'duration': '90 mins',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    final filteredPackages = _searchQuery == null || _searchQuery!.isEmpty
        ? _packages
        : _packages
              .where(
                (p) => p['name']!.toLowerCase().contains(
                  _searchQuery!.toLowerCase(),
                ),
              )
              .toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Package List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Config.spaceMedium,
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by package name',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              Config.spaceSmall,
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPackages.length,
                  itemBuilder: (context, index) {
                    final p = filteredPackages[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('${p['name']} (${p['duration']})'),
                        subtitle: Text('ID: ${p['id']} - ${p['price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // TODO: Navigate to edit page
                                Navigator.of(
                                  context,
                                ).push(MaterialPageRoute(builder: (_) => const EditPackagePage()));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // TODO: Implement delete action
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddPackagePage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
