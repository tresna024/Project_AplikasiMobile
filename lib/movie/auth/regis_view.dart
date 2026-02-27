import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPageUI extends StatefulWidget {
  const RegisterPageUI({super.key});

  @override
  State<RegisterPageUI> createState() => _RegisterPageUIState();
}

class _RegisterPageUIState extends State<RegisterPageUI> {
  bool notvisible = true;
  Icon passwordIcon = const Icon(Icons.visibility);

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Berhasil!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Akun Anda telah berhasil dibuat.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup popup
                Navigator.pop(context); // Kembali ke halaman Login
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ===== REGISTER FUNCTION =====
  Future<void> registerUser() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      showSuccessPopup(); // ⬅ tampilkan pop-up sukses
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Terjadi kesalahan")),
      );
    }
  }

  /// ===== PASSWORD TOGGLE =====
  void togglePassword() {
    setState(() {
      notvisible = !notvisible;
      passwordIcon = notvisible
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// LOGO TOP
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Image.asset(
                'assets/image/logo.png',
                width: 150,
                height: 150,
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Column(
                children: [
                  /// TITLE
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// EMAIL FIELD
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email_outlined,
                          color: Colors.grey),
                      labelText: 'Masukkan Email',
                      suffixIcon: Icon(Icons.email_outlined),
                    ),
                  ),

                  const SizedBox(height: 13),

                  /// PASSWORD FIELD
                  TextField(
                    controller: password,
                    obscureText: notvisible,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock_outline_rounded,
                          color: Colors.grey),
                      labelText: 'Masukkan Password',
                      suffixIcon: IconButton(
                        onPressed: togglePassword,
                        icon: passwordIcon,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// AGREEMENT TEXT
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'By signing up, you agree to our Terms & conditions and Privacy Policy',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// REGISTER BUTTON
                  ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF01d277),
                            Color(0xFF00a8e1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// GO TO LOGIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
