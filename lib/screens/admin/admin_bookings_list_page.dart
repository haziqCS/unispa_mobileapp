import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class AdminBookingsListPage extends StatefulWidget {
  const AdminBookingsListPage({super.key});

  @override
  State<AdminBookingsListPage> createState() => _AdminBookingsListPageState();
}

class _AdminBookingsListPageState extends State<AdminBookingsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _searchQuery;

  // Placeholder bookings
  final List<Map<String, String>> _bookings = [
    {
      'name': 'John Doe',
      'phone': '+60123456789',
      'package': 'Facial Treatment',
      'date': '2025-07-06',
      'time': '2:00 PM',
    },
    {
      'name': 'Jane Smith',
      'phone': '+60198765432',
      'package': 'Full Body Massage',
      'date': '2025-07-07',
      'time': '4:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    final filteredBookings = _searchQuery == null || _searchQuery!.isEmpty
        ? _bookings
        : _bookings
              .where(
                (b) => b['name']!.toLowerCase().contains(
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
                'Booking List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Config.spaceMedium,
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by customer name',
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
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(booking['name']!),
                        subtitle: Text(
                          '${booking['phone']}\n${booking['package']}\n${booking['date']} at ${booking['time']}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
