import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class AddPackagePage extends StatefulWidget {
  const AddPackagePage({super.key});

  @override
  State<AddPackagePage> createState() => _AddPackagePageState();
}

class _AddPackagePageState extends State<AddPackagePage> {
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
        title: const Text('Add New Package'),
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
