import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:5081/api/Auth";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      final msg = data["message"] ?? data["error"] ?? "Erro inesperado";

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user", jsonEncode(data["user"]));
        return {"success": true, "message": msg};
      }

      return {"success": false, "message": msg};
    } catch (e) {
      return {"success": false, "message": "Erro ao conectar com o servidor"};
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nome": name,
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      final msg = data["message"] ?? data["error"] ?? "Erro inesperado";

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "message": msg};
      }

      return {"success": false, "message": msg};
    } catch (e) {
      return {"success": false, "message": "Erro ao conectar com o servidor"};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
  }

  Future<Map<String, dynamic>?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");
    if (userJson == null) return null;
    return jsonDecode(userJson);
  }

  Future<String?> getLoggedUserName() async {
    final data = await getLoggedUser();
    return data?["nome"];
  }

  Future<Map<String, dynamic>?> getUserFromAPI() async {
    final localUser = await getLoggedUser();
    if (localUser == null) return null;

    final email = localUser["email"];
    final url = Uri.parse("$baseUrl/me");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("user");
  }
}
