import 'package:flutter/material.dart';

void main() {
  runApp(const ForgotPasswordScreen());
}

class ForgotPasswordScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ForgotPasswordScreen({Key? key});

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 5),
                  Image.asset(
                    'assets/logos/logo.png',
                    height: 200.0,
                    width: 300.0,
                  ),
                  const SizedBox(height: 80),
                  const Text(
                    'FORGOT PASSWORD',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
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
            _VersionTextVisibility(),
          ],
        ),
      ),
    );
  }
}
class ForgotForm extends StatelessWidget {
  const ForgotForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [ 
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: ' Username or e-mail',
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            // Handle login button press
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
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
    WidgetsBinding.instance.removeObserver(KeyboardVisibilityObserver(onKeyboardVisibilityChanged: (bool ) {  }));
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
