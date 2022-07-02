import 'package:flutter/material.dart';
import 'package:noted/constants/routes.dart';
import 'package:noted/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noted/services/auth/bloc/auth_bloc.dart';
import 'package:noted/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 179, 255),
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you a verification email. Please open it to verify your account"),
          const Text(
              "If you haven't recieved a verification email yet, please press the button below"),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );
            },
            child: const Text('Send Email Verification'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                    const AuthEventLogout(),
                  );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
