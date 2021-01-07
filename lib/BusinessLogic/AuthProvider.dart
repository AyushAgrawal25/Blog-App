import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum googleLoginStatus { success, alreadyExist, failure }

class AuthProvider {
  // final FirebaseAuth gpFirebaseAuth = FirebaseAuth.instance;

  Future<bool> loginWithGoogle() async {
    await Firebase.initializeApp();
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleAccount = await googleSignIn.signIn();

      if (googleAccount == null) {
        return false;
      } else {
        GoogleSignInAuthentication googleAuthentication =
            await googleAccount.authentication;
        fAuth.OAuthCredential fAuthCredential =
            fAuth.GoogleAuthProvider.credential(
                idToken: googleAuthentication.idToken,
                accessToken: googleAuthentication.accessToken);

        fAuth.UserCredential fUserCredential = await fAuth.FirebaseAuth.instance
            .signInWithCredential(fAuthCredential);

        if (fUserCredential.user == null) {
          return false;
        } else {
          return true;
        }
      }
    } catch (excep) {
      print(excep);
      print("Exception in Google Sign In Part..");
    }
  }

  Future<bool> isGoogleSigned() async {
    GoogleSignIn gpGoogleSignIn = GoogleSignIn();
    bool googleSignInStatus = await gpGoogleSignIn.isSignedIn();
    return googleSignInStatus;
  }

  Future<bool> googleSignOut() async {
    try {
      GoogleSignIn gpGoogleSignIn = GoogleSignIn();
      GoogleSignInAccount gpGoogleAccount = await gpGoogleSignIn.signOut();
      if (await gpGoogleSignIn.isSignedIn()) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<fAuth.User> getCurrentUser() async {
    try {
      fAuth.User gpUser = fAuth.FirebaseAuth.instance.currentUser;
      return gpUser;
    } catch (err) {
      return null;
    }
  }
}
