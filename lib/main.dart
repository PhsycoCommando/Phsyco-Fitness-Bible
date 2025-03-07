import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phsyco\'s Fitness Bible',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Sign-In")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await signInWithGoogle();
            if (user != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Signed in as ${user.user?.displayName}"),
                ),
              );
            }
          },
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}
