import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/components/button.dart';
import 'package:unispa_mobileapp/components/custom_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample user data placeholder
    final user = {
      'name': 'John Doe',
      'gender': 'Male',
      'phone': '+60123456789',
      'email': 'john.doe@example.com',
      'membership': 'Gold',
      'dateJoined': '2023-04-15',
    };

    Widget profileRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Profile',
        icon: const FaIcon(Icons.arrow_back),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileRow('Name', user['name']!),
              profileRow('Gender', user['gender']!),
              profileRow('Phone', user['phone']!),
              profileRow('Email', user['email']!),
              profileRow('Membership', user['membership']!),
              profileRow('Date Joined', user['dateJoined']!),
              const Spacer(),
              Button(
                width: double.infinity,
                title: 'Edit Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
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