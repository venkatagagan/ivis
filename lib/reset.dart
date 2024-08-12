import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/apis/login_api_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ResetScreen(),
    );
  }
}

class ResetScreen extends StatelessWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: Height * 0.03),
                    Row(
                      children: [
                        SizedBox(width: Width * 0.1),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                            // Your action when the image is tapped
                          },
                          child: Image.asset(
                            'assets/logos/logo.png',
                            height: Height * 0.04,
                            width: Width * 0.6,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Height * 0.05,
                    ),
                    const Text(
                      'RESET PASSWORD',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: Height * 0.03,
                    ),
                    Container(
                      width: Width * 0.8,
                      height: Height * 0.64,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const ResetForm(),
                    ),
                  ]),
                ),
              ),
              Positioned(
                bottom: 40,
                width: MediaQuery.of(context).size.width, // Full width
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Version 1.2.0',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetForm extends StatefulWidget {
  const ResetForm({Key? key}) : super(key: key);

  @override
  _PasswordValidatorState createState() => _PasswordValidatorState();
}

class _PasswordValidatorState extends State<ResetForm> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reenterPasswordController =
      TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _matched = false;

  bool _isPasswordValid = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  void _updatePassword() async {
    // Endpoint URL
    var url = Uri.parse('http://34.206.37.237/userDetails/updatePassword_1_0');

    // JSON payload
    var payload = {
      "userName": LoginApiService.UserName,
      "oldPassword": _oldPasswordController.text,
      "newPassword": _newPasswordController.text,
      "firstTime": "F",
    };

    // Encode payload to JSON
    var body = jsonEncode(payload);

    try {
      // Make PUT request
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      // Check response status code
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: Container(
                height: 140,
                width: 340,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "updated ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(top: 16),
                ),
              ],
            );
          },
        );
        print('Password update successful');
        print('Response body: ${response.body}');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: Container(
                height: 140,
                width: 340,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "invalid old password ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(top: 16),
                ),
              ],
            );
          },
        );
        print('Failed to update password. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _reenterPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return Container(
      height: Height * 0.3,
      child: Column(
        children: [
          SizedBox(height: Height * 0.01),
          TextFormField(
            controller: _oldPasswordController,
            decoration: const InputDecoration(
                labelText: 'Old Password',
                labelStyle: TextStyle(fontFamily: 'Montserrat'),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white),
          ),
          SizedBox(height: Height * 0.01),
          TextFormField(
            obscureText: !_showPassword,
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _isPasswordValid = value.length >= 6;

                _hasUppercase = _containsUppercase(value);
                _hasLowercase = _containsLowercase(value);
                _hasNumber = _containsNumber(value);
                _hasSpecialChar = _containsSpecialChar(value);
              });
            },
          ),
          SizedBox(height: Height * 0.01),
          TextFormField(
            obscureText: !_showPassword,
            controller: _reenterPasswordController,
            decoration: InputDecoration(
              labelText: _matched ? 'Enter New Password' : "Invalid",
              labelStyle: TextStyle(
                  color: _matched ? Colors.grey : Colors.red,
                  fontFamily: 'Montserrat'),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _matched = _newPasswordController.text == value;
              });
            },
          ),
          SizedBox(height: Height * 0.005),
          _buildPasswordCriteriaText('At least 6 characters', _isPasswordValid),
          _buildPasswordCriteriaText(
              'At least one uppercase letter', _hasUppercase),
          _buildPasswordCriteriaText(
              'At least one lowercase letter', _hasLowercase),
          _buildPasswordCriteriaText('At least one digit', _hasNumber),
          _buildPasswordCriteriaText(
              'At least one special character', _hasSpecialChar),
          SizedBox(height: Height * 0.025),
          ElevatedButton(
            onPressed: () {
              if (LoginApiService.Password == _oldPasswordController.text &&
                  _matched &&
                  _hasLowercase &&
                  _hasNumber &&
                  _hasUppercase &&
                  _isPasswordValid &&
                  _hasSpecialChar) {
                // Password meets all criteria
                _updatePassword();
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      content: Container(
                        height: 140,
                        width: 340,
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          "Invalid old password ",
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                        ),
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(Color(0xFF084982)),
              minimumSize: MaterialStateProperty.all(const Size(125, 50)),
            ),
            child: const Text(
              'SUBMIT',
              style: TextStyle(fontFamily: 'Montserrat',color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  bool _containsUppercase(String value) {
    return value.contains(new RegExp(r'[A-Z]'));
  }

  bool _containsLowercase(String value) {
    return value.contains(new RegExp(r'[a-z]'));
  }

  bool _containsNumber(String value) {
    return value.contains(new RegExp(r'[0-9]'));
  }

  bool _containsSpecialChar(String value) {
    return value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  Widget _buildPasswordCriteriaText(String text, bool isSatisfied) {
    double Width= MediaQuery.of(context).size.width;
    double Height= MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(
            isSatisfied ? Icons.check_circle : Icons.cancel,
            color: isSatisfied ? Colors.green : Colors.red,
          ),
          SizedBox(width: Width*0.05),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: isSatisfied ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
