import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/utils/auth_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();
  String _selectedGender = 'male'; // default gender
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) => v!.isEmpty ? 'Name required' : null,
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v!.isEmpty ? 'Email required' : null,
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone No'),
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Phone required' : null,
          ),
          Config.spaceSmall,
          _buildGenderSelector(),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passConfirmController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (v) =>
                v != _passController.text ? 'Passwords do not match' : null,
          ),
          Config.spaceSmall,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
  final genders = ['male', 'female', 'other'];
  return Wrap(
    spacing: 8,
    children: genders.map((g) {
      final isSelected = g == _selectedGender;
      return ChoiceChip(
        label: Text(g[0].toUpperCase() + g.substring(1)),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedGender = g;
          });
        },
      );
    }).toList(),
  );
}

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService();
      final result = await authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNo: _phoneController.text.trim(),
        gender: _selectedGender,
        password: _passController.text,
        passwordConfirmation: _passConfirmController.text,
      );

      if (result['success'] && mounted) {
        Config.showSnack(context, 'Registration successful!');
        Navigator.of(context).pushReplacementNamed('main');
      } else if (mounted) {
        Config.showSnack(context, result['message'] ?? 'Registration failed.');
      }
    }
  }
}
