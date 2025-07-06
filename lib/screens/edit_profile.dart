import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/components/button.dart';
import 'package:unispa_mobileapp/components/custom_appbar.dart';
import 'package:unispa_mobileapp/utils/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  String _formatGender(String gender) {
    final lower = gender.toLowerCase();
    if (lower == 'male') return 'Male';
    if (lower == 'female') return 'Female';
    return 'Other';
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final user = await _authService.getProfile();
    if (user != null) {
      _nameController.text = user['name'] ?? '';
      _genderController.text = _formatGender(user['gender'] ?? 'Male');
      _phoneController.text = user['phone_no'] ?? '';
      _emailController.text = user['email'] ?? '';
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final token = await _authService.getToken();
    final response = await _authService.updateProfile(
      token: token!,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _genderController.text.toLowerCase(),
      phone: _phoneController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (response && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      // ✅ Tell parent we saved successfully:
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Edit Profile',
        icon: const FaIcon(Icons.arrow_back),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Text(
                        'Update your information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceMedium,
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration('Full Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your name' : null,
                      ),
                      Config.spaceMedium,
                      DropdownButtonFormField<String>(
                        value: _genderController.text,
                        decoration: _inputDecoration('Gender'),
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'Female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          _genderController.text = value!;
                        },
                      ),
                      Config.spaceMedium,
                      TextFormField(
                        controller: _phoneController,
                        decoration: _inputDecoration('Phone Number'),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your phone number'
                            : null,
                        keyboardType: TextInputType.phone,
                      ),
                      Config.spaceMedium,
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration('Email Address'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your email' : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Config.spaceBig,
                      Button(
                        width: double.infinity,
                        title: 'Save Changes',
                        onPressed: _saveProfile,
                        disable: _isLoading,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
