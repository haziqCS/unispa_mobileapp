import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final invoiceNumber = args['invoiceNumber']?.toString() ?? 'N/A';
    final totalPrice = args['totalPrice'] ?? 0.0;
    final paymentStatus = args['paymentStatus']?.toString() ?? 'Unknown';
    final timestampString = args['timestamp']?.toString();

    String formattedTimestamp = 'N/A';
    if (timestampString != null && timestampString.isNotEmpty) {
      try {
        formattedTimestamp = DateFormat(
          'yyyy-MM-dd HH:mm',
        ).format(DateTime.parse(timestampString));
      } catch (e) {
        // If parsing fails, keep 'N/A'
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Invoice')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice #$invoiceNumber',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Price: RM ${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Payment Status: $paymentStatus',
              style: TextStyle(
                fontSize: 18,
                color: paymentStatus == 'Paid' ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: $formattedTimestamp',
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('main');
                },
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
