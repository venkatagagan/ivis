import 'package:flutter/material.dart';
import 'package:ivis_security/apis/login_api_service.dart';
import 'package:ivis_security/forgot_Pass.dart';

class LoginScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
      ),
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
                  SizedBox(height: Height * 0.1),
                  Image.asset(
                    'assets/logos/logo.png',
                    height: Height * 0.035,
                    width: Width * 0.65,
                  ),
                  SizedBox(height: Height * 0.1),
                  const Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: Height * 0.05),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const LoginForm(),
                  ),
                ],
              ),
            ),
            _VersionTextVisibility(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const LoginForm({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _showPassword = false;

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _handleLogin(BuildContext context) async {
    final user = userController.text;
    final password = passwordController.text;

    await LoginApiService.login(context, user, password);

    // Navigate to the next screen
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: Height * 0.04),
        TextFormField(
          controller: userController,
          decoration: const InputDecoration(
            labelText: 'Email ID Or UserName',
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        SizedBox(height: Height * 0.02),
        TextFormField(
          obscureText: !_showPassword,
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            filled: true,
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
        Row(
          children: [
            SizedBox(width: Width * 0.4),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: const Text(
                'Forgot Password?',
              ),
            ),
          ],
        ),
        SizedBox(height: Height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: false,
              onChanged: (bool? value) {
                // Handle checkbox state change
              },
            ),
            const Text(
              'Remember Me',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: Height * 0.025),
        ElevatedButton(
          onPressed: () {
            // Handle login button press
            _handleLogin(context);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'SIGN IN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _VersionTextVisibility extends StatefulWidget {
  @override
  __VersionTextVisibilityState createState() => __VersionTextVisibilityState();
}

class __VersionTextVisibilityState extends State<_VersionTextVisibility> {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(KeyboardVisibilityObserver(
      onKeyboardVisibilityChanged: (bool visible) {
        setState(() {
          _isKeyboardVisible = visible;
        });
      },
    ));
  }

  @override
  void dispose() {
    // ignore: avoid_types_as_parameter_names
    WidgetsBinding.instance.removeObserver(
        // ignore: avoid_types_as_parameter_names
        KeyboardVisibilityObserver(onKeyboardVisibilityChanged: (bool) {}));
    super.dispose();
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

class KeyboardVisibilityObserver extends WidgetsBindingObserver {
  final Function(bool) onKeyboardVisibilityChanged;

  KeyboardVisibilityObserver({required this.onKeyboardVisibilityChanged});

  @override
  void didChangeMetrics() {
    // ignore: deprecated_member_use
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    onKeyboardVisibilityChanged(bottomInset > 0);
  }
}
