import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/services/api_service.dart';

class EditPackagePage extends StatefulWidget {
  final Map<String, dynamic> package;
  const EditPackagePage({super.key, required this.package});

  @override
  State<EditPackagePage> createState() => _EditPackagePageState();
}

class _EditPackagePageState extends State<EditPackagePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _durationController;
  late TextEditingController _priceController;
  late TextEditingController _capacityController;

  @override
  void initState() {
    super.initState();

    final p = widget.package;

    print('Package data received: $p');

    _nameController = TextEditingController(text: p['package_name'] ?? '');
    _descController = TextEditingController(text: p['package_desc'] ?? '');

    final options = p['options'] as List<dynamic>?;

    _durationController = TextEditingController(
      text: options != null && options.isNotEmpty
          ? options[0]['duration'] ?? ''
          : '',
    );
    _priceController = TextEditingController(
      text: options != null && options.isNotEmpty
          ? options[0]['package_price']?.toString() ?? ''
          : '',
    );
    _capacityController = TextEditingController(
      text: options != null && options.isNotEmpty
          ? options[0]['capacity']?.toString() ?? ''
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _savePackage() async {
    if (_formKey.currentState!.validate()) {
      final options = widget.package['options'] as List<dynamic>?;

      final packageId = options != null && options.isNotEmpty
          ? options[0]['package_id'] as int?
          : null;

      if (packageId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Package ID not found.')),
        );
        return;
      }

      final packageName = _nameController.text;
      final packageDesc = _descController.text; // note: package_desc here
      final duration = _durationController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final capacity = int.tryParse(_capacityController.text) ?? 0;

      final optionsPayload = [
        {
          "package_id": packageId,
          "duration": duration,
          "package_price": price,
          "capacity": capacity,
        },
      ];

      final success = await ApiService().updatePackage(
        packageId: packageId,
        packageName: packageName,
        packageDesc: packageDesc, // <-- send packageDesc here
        options: optionsPayload, // <-- send options as list
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('✅ Package updated!')));
        }
        Navigator.of(context).pop();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Failed to update package!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Package')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Package Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Duration'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price (RM)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: 'Capacity'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                Config.spaceMedium,
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
