import 'package:flutter/material.dart';
import 'package:ivis_security/apis/ForgotApi.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Height * 0.05),
                  Image.asset(
                    'assets/logos/logo.png',
                    height: Height * 0.1,
                    width: Width * 0.8,
                  ),
                  SizedBox(height: Height * 0.1),
                  const Text(
                    'FORGOT PASSWORD',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: Height * 0.02),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const ForgotForm(),
                  ),
                ],
              ),
            ),
            const VersionTextVisibility(),
          ],
        ),
      ),
    );
  }
}

class ForgotForm extends StatefulWidget {
  const ForgotForm({Key? key}) : super(key: key);

  @override
  _ForgotFormState createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Username or e-mail',labelStyle: TextStyle(fontFamily: 'Montserrat',),
            border: OutlineInputBorder(),
            filled: true,
            
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            final String email = _emailController.text.trim();
            if (email.isNotEmpty) {
              ApiService.sendResetLink(context, email);
            } else {
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
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 40),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      size: 40,
                                    )
                                  ]),
                              SizedBox(height: 40),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Your email is invalid!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ]),
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
          },
          child: const Text('Send Reset Link',style: TextStyle(fontFamily: 'Montserrat',),),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class VersionTextVisibility extends StatefulWidget {
  const VersionTextVisibility({Key? key}) : super(key: key);

  @override
  _VersionTextVisibilityState createState() => _VersionTextVisibilityState();
}

class _VersionTextVisibilityState extends State<VersionTextVisibility>
    with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isKeyboardVisible ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(bottom: 40),
        child: const Text(
          'Version 1.2.0',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
