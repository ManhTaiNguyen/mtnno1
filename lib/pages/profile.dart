import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang cá nhân'),
      ),
      body: Column(
        children: [
          Text(
            auth.currentUser?.email ?? 'N/A',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          FilledButton.tonalIcon(
            onPressed: signOut,
            icon: Icon(Icons.logout),
            label: Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
