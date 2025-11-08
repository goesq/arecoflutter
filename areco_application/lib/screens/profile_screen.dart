import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getLoggedUser();
    if (user != null) {
      setState(() {
        userName = user["nome"] ?? "";
        userEmail = user["email"] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Meu Perfil',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.only(top: 130, left: 24, right: 24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: const Icon(Icons.person, size: 60, color: Colors.grey),
              ),

              const SizedBox(height: 18),

              Text(
                userName.isNotEmpty ? userName : "Carregando...",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                userEmail.isNotEmpty ? userEmail : "",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
