import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Positioned(
            top: 50,
            left: 71,
            child: Image.asset(
              'assets/logos/logo.png',
              height: 26.87,
              width: 218.25,
            ),
          ),
          Positioned(
            top: 152,
            left: (MediaQuery.of(context).size.width - 200) /
                2, // Adjusted center alignment
            child: const Text(
              'RESET PASSWORD',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: 30,
            child: Container(
              width: 300,
              height: 450,
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
                ),
              ),
            ),
          ),
        ],
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
  final TextEditingController _reenterPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  

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
      height: Height*0.5,
      child: Column(
        children: [
          SizedBox(height: Height * 0.04),
          TextFormField(
            controller: _oldPasswordController,
            decoration: const InputDecoration(
                labelText: 'Email ID Or UserName',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white),
          ),
          SizedBox(height: Height * 0.02),
          TextFormField(
            obscureText: !_showPassword,
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: 'New Password',
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
          ),
          SizedBox(height: Height * 0.02),
          TextFormField(
            obscureText: !_showPassword,
            controller: _reenterPasswordController,
            decoration: InputDecoration(
              labelText: 'Enter New Password',
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
          ),
          SizedBox(height: Height * 0.025),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Password meets all criteria
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password is valid'),
                  ),
                );
              }
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
                        "Reset password link has been sent to your registered e-mail id",
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
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              minimumSize: MaterialStateProperty.all(const Size(125, 50)),
            ),
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  
}
