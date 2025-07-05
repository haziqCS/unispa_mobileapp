import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder booking data
    final List<Map<String, dynamic>> bookingHistory = [
      {
        'packageName': 'Full Body Massage',
        'date': '2024-07-05',
        'time': '2:00 PM',
        'status': 'Completed',
      },
      {
        'packageName': 'Facial Treatment',
        'date': '2024-06-20',
        'time': '11:00 AM',
        'status': 'Cancelled',
      },
      {
        'packageName': 'Spa & Sauna',
        'date': '2024-05-15',
        'time': '4:00 PM',
        'status': 'Completed',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: bookingHistory.isEmpty
              ? const Center(
                  child: Text(
                    'No booking history yet.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking History',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Config.spaceMedium,
                    Expanded(
                      child: ListView.builder(
                        itemCount: bookingHistory.length,
                        itemBuilder: (context, index) {
                          final booking = bookingHistory[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking['packageName'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Date: ${booking['date']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Time: ${booking['time']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: booking['status'] == 'Completed'
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    booking['status'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: booking['status'] == 'Completed'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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