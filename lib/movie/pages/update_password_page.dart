import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  bool _loading = false;

  Future<void> _updatePassword() async {
    try {
      setState(() => _loading = true);

      final user = FirebaseAuth.instance.currentUser!;
      final oldPass = _oldPassController.text.trim();
      final newPass = _newPassController.text.trim();

      // 1. Reauthenticate
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPass,
      );
      await user.reauthenticateWithCredential(cred);

      // 2. Update password
      await user.updatePassword(newPass);

      // 3. Show success
      setState(() => _loading = false);

      // Tampilkan popup sukses
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text(
              "Berhasil!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text("Password kamu berhasil diperbarui."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali ke ProfilePage
                },
                child: const Text("OK"),
              )
            ],
          );
        },
      );
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Password")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _oldPassController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password Lama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _newPassController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password Baru",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    text: "Update Password",
                    onPressed: _updatePassword,
                  ),
                ],
              ),
            ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF01B4E4),
            Color(0xFF90CEA1),
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
