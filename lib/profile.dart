import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final Function(Map<String, String>) onProfileUpdated;
  final VoidCallback onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onProfileUpdated,
    required this.onThemeChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _emailController.text = widget.userEmail;
  }

  void _saveProfile() {
    widget.onProfileUpdated({'name': _nameController.text, 'email': _emailController.text});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeChanged,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
