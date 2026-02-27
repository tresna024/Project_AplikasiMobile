import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_flutter/movie/pages/update_email_page.dart';
import 'package:project_flutter/movie/pages/update_password_page.dart';

// import 'update_email_page.dart';
// import 'update_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final _nameController = TextEditingController();

  bool _loading = false;
  bool _editMode = false;
  
  bool isGoogleUser(User user) {
    return user.providerData.any(
      (provider) => provider.providerId == "google.com",
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = user.displayName ?? "";
  }

  // =====================================================
  // PILIH FOTO DARI GALERI + UPLOAD STORAGE + UPDATE USER
  // =====================================================
  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() => _loading = true);

    final file = File(picked.path);
    final storageRef =
        FirebaseStorage.instance.ref().child("user_photos/${user.uid}.jpg");

    // Upload foto
    await storageRef.putFile(file);

    // Ambil URL
    final photoUrl = await storageRef.getDownloadURL();

    // Update Firebase Auth
    await user.updatePhotoURL(photoUrl);

    await user.reload();
    setState(() {
      _loading = false;
    });
  }

  // =====================================================
  // UPDATE DISPLAY NAME
  // =====================================================
  Future<void> _updateName() async {
    setState(() => _loading = true);

    await user.updateDisplayName(_nameController.text.trim());
    await user.reload();

    setState(() {
      _loading = false;
      _editMode = false; // kembali ke mode view
    });
  }

  @override
  Widget build(BuildContext context) {
    final refreshedUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        actions: [
          if (!_editMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => _editMode = true);
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: _editMode
                  ? _buildEditMode(refreshedUser)
                  : _buildViewMode(refreshedUser),
            ),
    );
  }

  // ==========================================================
  //             MODE VIEW — Tampilan Profil Biasa
  // ==========================================================
  Widget _buildViewMode(User? user) {
    
    final googleLogin = isGoogleUser(user!);

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              user.photoURL != null ? NetworkImage(user.photoURL!) : null,
          child:
              user.photoURL == null ? const Icon(Icons.person, size: 50) : null,
        ),

        const SizedBox(height: 20),

        Text(
          user.displayName ?? "No Name",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Text(
          user.email ?? "",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),

        const SizedBox(height: 30),

        // ======================================================
        //      TAMPILKAN "UBAH PASSWORD" HANYA JIKA BUKAN GOOGLE
        // ======================================================
        if (!googleLogin) ...[
          GradientButton(
            text: "Ubah Password",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UpdatePasswordPage()),
              );
            },
          ),
          const SizedBox(height: 10),
        ],

        // ======================================================
        //  UBAH EMAIL SELALU TAMPIL (GOOGLE USER JUGA BOLEH)
        // ======================================================
        GradientButton(
          text: "Ubah Email",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UpdateEmailPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEditMode(User? user) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickAndUploadPhoto,
          child: CircleAvatar(
            radius: 50,
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Nama Baru",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GradientButton(
                text: "Simpan",
                onPressed: _updateName,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _editMode = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Batal"),
              ),
            ),
          ],
        )
      ],
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
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF01B4E4), // Biru TMDB
            Color(0xFF90CEA1), // Hijau TMDB
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
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
