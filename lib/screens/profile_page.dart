import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/components/button.dart';
import 'package:unispa_mobileapp/components/custom_appbar.dart';
import 'package:unispa_mobileapp/utils/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authService = AuthService();
    final profile = await authService.getProfile(); // Implement this
    if (mounted) {
      setState(() {
        user = profile;
        isLoading = false;
      });
    }
  }

  Widget profileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Config.primaryColor,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final authService = AuthService();
              final success = await authService.logout();
              if (success && mounted) {
                Config.showSnack(context, 'Logged out successfully!');
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              } else if (mounted) {
                Config.showSnack(context, 'Logout failed.');
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Profile',
        icon: const FaIcon(Icons.arrow_back),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : user == null
            ? const Center(child: Text('Failed to load profile.'))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Config.primaryColor.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Config.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    profileRow('Name', user!['name'] ?? '-'),
                    profileRow('Gender', user!['gender'] ?? '-'),
                    profileRow('Phone', user!['phone_no'] ?? '-'),
                    profileRow('Email', user!['email'] ?? '-'),
                    profileRow(
                      'Membership',
                      user!['is_member'] == true ? 'Yes' : 'No',
                    ),
                    profileRow(
                      'Date Joined',
                      user!['created_at']?.substring(0, 10) ?? '-',
                    ),
                    const SizedBox(height: 30),
                    Button(
                      width: double.infinity,
                      title: 'Edit Profile',
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );

                        if (result == true) {
                          _loadProfile(); // ✅ Only reload if profile was saved
                        }
                      },
                      disable: false,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: const Text('Log Out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _confirmLogout(context),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
