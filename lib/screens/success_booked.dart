import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unispa_mobileapp/components/button.dart';

class AppointmentBooked extends StatelessWidget {
  const AppointmentBooked({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder invoice data
    final invoiceData = {
      'invoiceNumber': 'INV-20240705',
      'totalPrice': 150.00,
      'paymentStatus': 'Paid',
      'timestamp': DateTime.now().toString(),
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 3, child: Lottie.asset('assets/success.json')),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Successfully Booked',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Button(
                width: double.infinity,
                title: 'View Invoice',
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    'invoice',
                    arguments: invoiceData,
                  );
                },
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}