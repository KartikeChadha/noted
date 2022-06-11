import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noted/constants/routes.dart';
import 'package:noted/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 179, 255),
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  if (user?.emailVerified ?? false) {
                    //email is verified
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (_) => false,
                    );
                  } else {
                    //email is NOT verified
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (_) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  } else if (e.code == 'wrong-password') {
                    await showErrorDialog(
                      context,
                      'Wrong password',
                    );
                  } else {
                    await showErrorDialog(
                      context,
                      'Error: ${e.code}',
                    );
                  }
                } catch (e) {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                }
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered yet? Register here'))
        ],
      ),
    );
  }
}
