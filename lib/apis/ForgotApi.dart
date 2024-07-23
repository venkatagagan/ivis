// lib/api_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> sendResetLink(BuildContext context, String email) async {
    final String url =
        'http://34.206.37.237/userDetails/sendResetLink_1_0/$email';
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String status = jsonResponse['Status'];

        if (status == 'Success') {
          _showDialog(context, 'Success',
              'New password link has been sent to your registered e-mail id.',email);
        } else {
          _showDialog(context, 'Error', 'Enter a valid e mail',email);
        }
      } else {
        _showDialog(context, 'Error', 'Server error: ${response.statusCode}',email);
      }
    } catch (e) {
      _showDialog(context, 'Error', 'An error occurred. Please try again.',email);
    }
  }

  static void _showDialog(BuildContext context, String title, String content,String mail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    
                  ],
                ),
              ),
              Positioned(
                          top: -15,
                          right: -15,
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
                                size: 30,
                                color: Colors
                                    .white, // This color is ignored but should be set to something that contrasts with the gradient
                              ),
                              onPressed: () {
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
