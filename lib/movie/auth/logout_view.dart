import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_flutter/movie/auth/login_view.dart'; // sesuaikan lokasi file login kamu

class LogoutView extends StatelessWidget {
  const LogoutView({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Hapus seluruh route, kembali ke LoginPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPageUI()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logout"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                size: 70,
                color: Colors.red,
              ),
              const SizedBox(height: 20),

              const Text(
                "Apakah Anda yakin ingin logout?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 30),

              // Tombol Logout
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(200, 45),
                ),
                onPressed: () => _logout(context),
                child: const Text("Logout"),
              ),

              const SizedBox(height: 10),

              // Tombol Batal
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
