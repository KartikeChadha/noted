import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noted/constants/routes.dart';
import 'package:noted/services/auth/auth_service.dart';
import 'package:noted/services/auth/bloc/auth_bloc.dart';
import 'package:noted/services/auth/bloc/auth_state.dart';
import 'package:noted/services/auth/firebase_auth_provider.dart';
import 'package:noted/views/login_view.dart';
import 'package:noted/views/notes/create_update_note_view.dart';
import 'package:noted/views/notes/notes_view.dart';
import 'package:noted/views/register_view.dart';
import 'package:noted/views/verify_email_view.dart';
import 'package:path/path.dart';

import 'services/auth/bloc/auth_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

//Home page
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
