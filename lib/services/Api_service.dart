import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Change these to match your actual backend
  // final String baseUrl = 'http://192.168.150.1:3000'; // Node backend
  final String baseUrl = 'https://zhingscanserver.onrender.com';
  // final String modelUrl = 'http://192.168.131.104:5000'; // Flask ML server
  final String modelUrl = 'https://sangay123-apcm.hf.space';

  /* ─────────────── AUTH ─────────────── */

  Future<Map<String, dynamic>> login({
    required String cid,
    required String password,
  }) async {
    print('[DEBUG] Logging in user: $cid');
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cid': cid, 'password': password}),
    );

    print('[DEBUG] Login response: ${res.statusCode} ${res.body}');
    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {
        'token': data['token'],
        'cid': data['user']['cid'],
        'userRole': data['user']['role'],
        'name': data['user']['name'],
      };
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }

  Future<void> signup({
    required String cid,
    required String password,
    required String email,
    required String contact,
    required String dzongkhag,
    required String gewog,
    required String dob,
    required String role,
    required String name,
  }) async {
    print('[DEBUG] Signing up user: $cid');
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cid': cid,
        'name': name,
        'password': password,
        'email': email,
        'contact': contact,
        'dzongkhag': dzongkhag,
        'gewog': gewog,
        'dob': dob,
        'role': role,
      }),
    );

    print('[DEBUG] Signup response: ${res.statusCode} ${res.body}');
    if (res.statusCode != 201) {
      final data = jsonDecode(res.body);
      throw Exception(data['message'] ?? 'Signup failed');
    }
  }

  /* ─────────────── PASSWORD / OTP ─────────────── */

  Future<void> sendOTP({required String email}) async {
    print('[DEBUG] Sending OTP to $email');
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    print('[DEBUG] sendOTP response: ${res.statusCode} ${res.body}');
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(data['error'] ?? 'Failed to send OTP');
    }
  }

  Future<void> verifyOTP({required String email, required String otp}) async {
    print('[DEBUG] Verifying OTP for $email');
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-otp/$email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'otp': otp}),
    );

    print('[DEBUG] verifyOTP response: ${res.statusCode} ${res.body}');
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(data['error'] ?? 'OTP verification failed');
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    print('[DEBUG] Resetting password for $email');
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/reset-password/$email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
    );

    print('[DEBUG] resetPassword response: ${res.statusCode} ${res.body}');
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(data['error'] ?? 'Password reset failed');
    }
  }

  /* ─────────────── PREDICT DISEASE (Flask) ─────────────── */

  Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    print('[DEBUG] Sending image to Flask /predict');
    final uri = Uri.parse('$modelUrl/predict');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    print('[DEBUG] predictDisease response: ${res.statusCode} ${res.body}');
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      final data = jsonDecode(res.body);
      throw Exception(data['error'] ?? 'Prediction failed');
    }
  }

  /* ─────────────── UPLOAD SCAN (Node) ─────────────── */

  Future<Map<String, dynamic>> uploadScan({
    required File imageFile,
    required String disease,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/api/scan');
    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['disease'] = disease
          ..files.add(
            await http.MultipartFile.fromPath(
              'plantImage',
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 201) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Invalid JSON: ${response.body}');
      }
    } else {
      throw Exception('Upload failed: ${response.body}');
    }
  }

  /* ─────────────── FORWARD SCAN ─────────────── */

  Future<Map<String, dynamic>> forwardScanToAdmin({
    required String scanId,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/api/scans/$scanId/forward');
    final res = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('[DEBUG] forwardScanToAdmin response: ${res.statusCode} ${res.body}');
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Forwarding failed: ${res.body}');
    }
  }

  /* ─────────────── GET FORWARDED SCANS ─────────────── */

  Future<List<dynamic>> getForwardedScans({required String token}) async {
    final uri = Uri.parse('$baseUrl/api/scans?status=sent_to_admin');
    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('[DEBUG] getForwardedScans response: ${res.statusCode}');
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to fetch forwarded scans');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser({required String token}) async {
    final uri = Uri.parse('$baseUrl/api/auth/me');
    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('[DEBUG] getCurrentUser response: ${res.statusCode}');
    if (res.statusCode == 200) {
      return jsonDecode(res.body); // returns {'user': {...}}
    } else {
      throw Exception('Failed to fetch current user');
    }
  }
}
