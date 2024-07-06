import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_user/models/user.dart';

class ApiService {
  final String baseUrl = "https://reqres.in/api";

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> fetchUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<http.Response> createUser(String name, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
      }),
    );
    return response;
  }

  Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'phone': user.phone,
        'address': user.address,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }
}
