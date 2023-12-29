// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/home.dart';

class LoginApiService {
  // static const baseUrl = 'http://34.206.37.237/userDetails/';
// ignore: non_constant_identifier_names
  static String UserName = '';
  static Future<void> login(
      BuildContext context, String user, String password) async {
    try {
      final Map<String, dynamic> requestBody = {
        "userName": user,
        "password": password,
      };
      final String requestBodyString = jsonEncode(requestBody);

      final response = await http.post(
        Uri.parse('http://34.206.37.237/userDetails/user_login_1_0?userName'),
        headers: {'Content-Type': 'application/json'},
        body: requestBodyString,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // ignore: non_constant_identifier_names
        String Status = jsonResponse['Status'];
        UserName = jsonResponse['UserName'];
        if (Status == 'Success') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Login Failed'),
                content: const Text(
                    'Incorrect username or password. Please try again.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
