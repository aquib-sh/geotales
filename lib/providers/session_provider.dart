import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();

  final FirebaseAuth _firebaseAuth;
  String? userId;
  String? email;
  String? userCountry;
  String? userCity;
  String? selectedCountry;
  String? selectedCity;

  SessionProvider(this._firebaseAuth);

  Future<String?> signIn() async {
    String enteredEmail = emailFieldController.text.trim();
    String enteredPassword = passwordFieldController.text.trim();

    try {
      final UserCredential result =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: enteredEmail, password: enteredPassword);
      userId = result.user?.uid; // update the userId
      email = enteredEmail; // update the email

      // clear fields before returning
      emailFieldController.clear();
      passwordFieldController.clear();

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp() async {
    try {
      String enteredEmail = emailFieldController.text.trim();

      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: enteredEmail,
        password: passwordFieldController.text.trim(),
      );
      userId = result.user?.uid;
      email = enteredEmail;
      emailFieldController.clear();
      passwordFieldController.clear();
      notifyListeners();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void setSelectedCountry(String country) {
    selectedCountry = country;
    selectedCity = null;
    notifyListeners();
  }

  void setSelectedCity(String city) {
    selectedCity = city;
    notifyListeners();
  }
}
