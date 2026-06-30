import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  final namaController = TextEditingController();
  final nbiController = TextEditingController();
  final jurusanController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    namaController.text = user?.displayName ?? "";
    nbiController.text = "1462300215";
    jurusanController.text = "Teknik Informatika";
  }

  Future<void> simpanProfil() async {
    if (namaController.text.isEmpty ||
        nbiController.text.isEmpty ||
        jurusanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua data wajib diisi"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    await user?.updateDisplayName(namaController.text.trim());
    await user?.reload();

    if (!mounted) return;

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil berhasil diperbarui"),
      ),
    );

    Navigator.pop(context, {
      "nama": namaController.text.trim(),
      "nbi": nbiController.text.trim(),
      "jurusan": jurusanController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(
                    Icons.person,
                    color: Colors.red,
                    size: 55,
                  ),
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: nbiController,
                  decoration: const InputDecoration(
                    labelText: "NBI",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: jurusanController,
                  decoration: const InputDecoration(
                    labelText: "Jurusan / Program Studi",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: isLoading ? null : simpanProfil,
                    icon: const Icon(Icons.save),
                    label: isLoading
                        ? const Text("Menyimpan...")
                        : const Text("Simpan Perubahan"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}