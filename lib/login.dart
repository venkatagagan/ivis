import 'package:flutter/material.dart';
import 'package:ivis_security/apis/login_api_service.dart';
import 'package:ivis_security/forgot_Pass.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Height * 0.05),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
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
  void initState() {
    super.initState();
    loadSavedCredentials(); // Load saved credentials when widget initializes
  }

  bool isChecked = false;
 

  Future<void> loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isChecked = prefs.getBool('isChecked') ?? false;
      if (isChecked) {
        userController.text = prefs.getString('username') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isChecked', isChecked);
    if (isChecked) {
      await prefs.setString('username', userController.text);
      await prefs.setString('password', passwordController.text);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
    }
  }

  void handleCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
      if (!isChecked) {
        // Clear username and password if checkbox is unchecked
        userController.text = '';
        passwordController.text = '';
      }
    });
    saveCredentials(); // Save credentials whenever checkbox state changes
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
            labelText: 'Email ID Or UserName',labelStyle:TextStyle(color: Color(0xFFABABAB),fontFamily: 'Montserrat',),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFFEFEFEF)
          ),
        ),
        SizedBox(height: Height * 0.02),
        TextFormField(
          obscureText: !_showPassword,
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',labelStyle:TextStyle(color: Color(0xFFABABAB),fontFamily: 'Montserrat',),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFFEFEFEF),
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
                'Forgot Password?',style:TextStyle(color: Color(0xFFABABAB),fontFamily: 'Montserrat',fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        SizedBox(height: Height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: handleCheckbox,
              activeColor: Color(0xFF084982),
            ),
            const Text(
              'Remember Me',
              style: TextStyle(
                color: Color(0xFF084982),//#084982
                fontSize: 20,
                fontFamily: 'Montserrat',
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
            backgroundColor: Color(0xFF084982),
          ),
          child: const Text(
            'SIGN IN',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20,
              fontFamily: 'Montserrat',
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
            color:Color(0xFFFFFFFF),
            fontSize: 16,
            fontFamily: 'Montserrat',
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
