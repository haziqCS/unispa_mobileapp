import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unispa_mobileapp/components/button.dart';
import 'package:unispa_mobileapp/components/custom_appbar.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
   Map<String, dynamic>? invoiceData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // This runs once when dependencies change (including first build)
    if (invoiceData == null) {
      // so this runs only once
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      invoiceData = args != null ? args['invoice'] : null;

      Timer(const Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed(
          'success_booking',
          arguments: {'invoice': invoiceData},
        );
      });
    }
  }

  void _showPaymentCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment Complete'),
        content: const Text('Thank you for your payment!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushReplacementNamed('success_booking');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Payment',
        icon: const FaIcon(Icons.arrow_back),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Scan the QR Code to Pay',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/qr.jpg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Button(
                width: double.infinity,
                title: 'Cancel Payment',
                onPressed: () {
                  Navigator.of(context).pop();
                },
                disable: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
