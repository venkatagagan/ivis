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
  static String Password = '';

  static Future<void> login(
      BuildContext context, String user, String password) async {
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
        Password = password;
        String Status = jsonResponse['Status'];
        UserId = jsonResponse['UserId'];
        UserName = jsonResponse['UserName'];

        if (Status == 'Success') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          _showDialog(
              context, 'Sign In Failed', 'Invalid username or password.');
        }
      } else {
        _showDialog(
            context, 'Sign In Failed', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
      _showDialog(context, 'Sign In Failed', 'Invalid username or password.');
    }
  }
  
  static void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            clipBehavior: Clip
                .none, // This allows the button to be half outside the dialog
            children: [
               Container(
                decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(5),
                    ),
              child:Padding(
                padding: const EdgeInsets.all(16.0),
                
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    SizedBox(height: 40),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    SizedBox(height: 20),
                  ],
                ),
              ),
               ),
              Positioned(
                top: -20,
                right: -20,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Color(0xFFD34124), Color(0xFF084982)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      size: 25,
                      color: Colors
                          .white, // This color is ignored but should be set to something that contrasts with the gradient
                    ),
                    onPressed: () {
                      // Add your onPressed functionality here
                       Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
