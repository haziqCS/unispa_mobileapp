import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class EditPackagePage extends StatefulWidget {
  const EditPackagePage({super.key});

  @override
  State<EditPackagePage> createState() => _EditPackagePageState();
}

class _EditPackagePageState extends State<EditPackagePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _savePackage() {
    if (_formKey.currentState!.validate()) {
      final newPackage = {
        'name': _nameController.text,
        'duration': _durationController.text,
        'capacity': _capacityController.text,
        'price': _priceController.text,
      };

      // TODO: Save to database or API
      print('Package saved: $newPackage');

      Navigator.of(context).pop(); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Package Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Package Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Duration (min)'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: 'Capacity'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price (RM)'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                Config.spaceSmall,
                ElevatedButton(
                  onPressed: _savePackage,
                  child: const Text('Save Package'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
