import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    // Dummy stats placeholder
    final stats = {
      'totalSales': 'RM 12,500',
      'totalBookings': '53',
      'popularPackage': 'Full Body Massage',
    };

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Admin Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/');
                    },
                    child: const Icon(FontAwesomeIcons.arrowRightFromBracket),
                  ),
                ],
              ),
              Config.spaceMedium,

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _statRow('Total Sales', stats['totalSales']!),
                      Config.spaceSmall,
                      _statRow('Total Bookings', stats['totalBookings']!),
                      Config.spaceSmall,
                      _statRow('Popular Package', stats['popularPackage']!),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Keep up the good work, Admin!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Config.spaceMedium,
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
