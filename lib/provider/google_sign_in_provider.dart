import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider with ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;
  GoogleSignInAuthentication? auth;

  Future<void> login() async {
    this.googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      auth = await googleAccount!.authentication;
    }
    notifyListeners();
  }

  logout() async {
    await _googleSignIn.signOut();
    googleAccount = null;
    auth = null;
    notifyListeners();
  }
}
