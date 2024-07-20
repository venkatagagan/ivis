// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/home.dart';

class LoginApiService {
  // static const baseUrl = 'http://34.206.37.237/userDetails/';
  // ignore: non_constant_identifier_names
  static String UserName = '';
  static int UserId = 0;
  static String Password='';
  

  static Future<void> login(BuildContext context, String user, String password) async {
    try {
      
      final Map<String, dynamic> requestBody = {
        "userName": user,
        "password": password,
      };
      final String requestBodyString = jsonEncode(requestBody);

      final response = await http.post(
        Uri.parse('http://34.206.37.237/userDetails/user_login_1_0'),
        headers: {'Content-Type': 'application/json'},
        body: requestBodyString,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Password=password;
        String Status = jsonResponse['Status'];
        UserId = jsonResponse['UserId'];
        UserName = jsonResponse['UserName'];
        
        if (Status == 'Success') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          _showDialog(context, 'Sign In Failed', 'Invalid username or password.');
        }
        
      } else {
        _showDialog(context, 'Sign In Failed', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
      _showDialog(context, 'Sign In Failed', 'An error occurred. Please try again.');
    }
  }

  static void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
