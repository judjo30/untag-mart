import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  String nama = "";
  String nbi = "1462300215";
  String jurusan = "Teknik Informatika";

  @override
  void initState() {
    super.initState();
    nama = user?.displayName ?? "Juan Prawira";
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> bukaEditProfil() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        nama = result["nama"] ?? nama;
        nbi = result["nbi"] ?? nbi;
        jurusan = result["jurusan"] ?? jurusan;
        user = FirebaseAuth.instance.currentUser;
      });
    }
  }

  Widget infoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.red,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 65,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    nama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? "-",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(
                        Icons.edit,
                        color: Colors.teal,
                      ),
                      title: const Text("Edit Profil"),
                      subtitle: const Text("Ubah nama, NBI, dan jurusan"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: bukaEditProfil,
                    ),
                  ),

                  infoTile(
                    icon: Icons.badge,
                    title: "NBI",
                    subtitle: nbi,
                  ),

                  infoTile(
                    icon: Icons.school,
                    title: "Program Studi",
                    subtitle: jurusan,
                  ),

                  infoTile(
                    icon: Icons.account_balance,
                    title: "Universitas",
                    subtitle: "Universitas 17 Agustus 1945 Surabaya",
                  ),

                  infoTile(
                    icon: Icons.email,
                    title: "Email",
                    subtitle: user?.email ?? "-",
                  ),

                  infoTile(
                    icon: Icons.info,
                    title: "Versi Aplikasi",
                    subtitle: "UNTAG Mart v1.0.0",
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}