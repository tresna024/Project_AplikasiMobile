import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_flutter/movie/auth/regis_view.dart';
import 'package:project_flutter/movie/pages/movie_page.dart';

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({super.key});

  @override
  State<LoginPageUI> createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {
  bool notvisible = true;
  bool emailFormVisibility = true;
  Icon passwordIcon = const Icon(Icons.visibility);

  final TextEditingController id = TextEditingController();
  final TextEditingController password = TextEditingController();

  void togglePassword() {
    setState(() {
      notvisible = !notvisible;
      passwordIcon = notvisible
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off);
    });
  }

  Future<void> loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id.text.trim(),
        password: password.text.trim(),
      );

      showLoginSuccessPopup();
    } on FirebaseAuthException catch (e) {
      showErrorPopup(e.message ?? "Login gagal, periksa email & password.");
    }
  }

  void showLoginSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Login Berhasil!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Anda berhasil masuk."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup popup
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MoviePage()),
                );
              },
              child: const Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> loginWithGoogle() async {
    try {
      // 🔥 Tambahkan ini agar selalu muncul pemilihan akun
      await GoogleSignIn().signOut();

      // 1. Trigger Google Sign-In (akan selalu tampil pop-up akun)
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return; // User menutup pop-up Google
      }

      // 2. Ambil detail autentikasi
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Buat credential untuk Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Login ke Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // 5. Pop-up berhasil
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Google Berhasil!"),
          content: Text("Selamat datang, ${googleUser.displayName}!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MoviePage()),
                );
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      // Jika error
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Login Google Error",
            style: TextStyle(color: Colors.red),
          ),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  void showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Login Gagal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
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

            /// Logo
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child:
                  Image.asset('assets/image/logo.png', width: 150, height: 150),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Email Form
                  Visibility(
                    visible: emailFormVisibility,
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.alternate_email_outlined,
                                color: Colors.grey),
                            labelText: 'Masukkan Email',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  emailFormVisibility = false;
                                });
                              },
                              icon: const Icon(Icons.mail_outline_rounded),
                            ),
                          ),
                          controller: id,
                        ),
                        const SizedBox(height: 13),
                        TextField(
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
                          controller: password,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 13),

                  /// Forgot Password
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// LOGIN BUTTON
                  ElevatedButton(
                    onPressed: loginUser,
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
                            Color(0xFF01d277), // TMDB green
                            Color(0xFF00a8e1), // TMDB blue
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
                          "Login",
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

                  /// Divider OR
                  Stack(
                    children: [
                      const Divider(thickness: 1),
                      Center(
                        child: Container(
                          color: Colors.white,
                          width: 70,
                          child: const Center(
                            child: Text(
                              "OR",
                              style: TextStyle(
                                  fontSize: 15, backgroundColor: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Login Google (dummy)
                  ElevatedButton.icon(
                    onPressed: loginWithGoogle,
                    icon: Image.asset(
                      'assets/image/google_logo.png',
                      width: 20,
                      height: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      backgroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    label: const Text(
                      "Login with Google",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Register Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "New to the App? ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPageUI()),
                          );
                        },
                        child: const Text(
                          "Register",
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
