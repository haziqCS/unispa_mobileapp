import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unispa_mobileapp/components/button.dart';
import '../components/custom_appbar.dart';

class PackageDetails extends StatefulWidget {
  const PackageDetails({super.key});

  @override
  State<PackageDetails> createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  int? selectedPackageId;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final options = args['options'] as List;

    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Package Details',
        icon: const FaIcon(Icons.arrow_back),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                args['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              Text(
                args['desc'],
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              Config.spaceMedium,
              const Text(
                'Choose a Package Option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Config.spaceSmall,
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected =
                        selectedPackageId == option['package_id'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPackageId = option['package_id'];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Config.primaryColor.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Config.primaryColor
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option['duration'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'RM ${option['package_price']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Capacity: ${option['capacity']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 28,
                              )
                            else
                              const Icon(
                                Icons.radio_button_unchecked,
                                color: Colors.grey,
                                size: 28,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Button(
                width: double.infinity,
                title: 'Book Now',
                onPressed: selectedPackageId == null
                    ? () {} // <-- empty function, never null
                    : () {
                        Navigator.of(context).pushNamed(
                          'booking_page',
                          arguments: {
                            'package_id': selectedPackageId,
                            'package_name': args['name'],
                          },
                        );
                      },
                disable: selectedPackageId == null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
