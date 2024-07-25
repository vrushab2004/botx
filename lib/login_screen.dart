import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                final authService = Provider.of<AuthService>(context, listen: false);
                authService.signInWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                  context,
                  showSnackBar,
                );
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registerScreen');
              },
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  showSnackBar("Please enter your email.");
                  return;
                }

                final authService = Provider.of<AuthService>(context, listen: false);
                final emailExists = await authService.checkIfEmailExists(email);

                if (emailExists) {
                  await authService.sendPasswordResetEmail(email);
                  showSnackBar("Password reset email sent.");
                } else {
                  showSnackBar("Email does not exist.");
                }
              },
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
