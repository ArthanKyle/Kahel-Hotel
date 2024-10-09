import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../utils/mpin_hash.dart';

class AuthResponse {
  final UserCredential? userCredential;
  final String? errorMessage;

  AuthResponse({this.userCredential, this.errorMessage});
}


Future<AuthResponse> createAccAPI({required UserModel user, required String password}) async {
  try {
    // Create a new user with email and password using Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(user.toJson());
    // Return the userCredential in the response
    return AuthResponse(userCredential: userCredential);
  } catch (e) {
    // Handle and return error in AuthResponse
    return AuthResponse(errorMessage: e.toString());
  }
}
Future<AuthResponse> signIn({required String email, required String password}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return AuthResponse(userCredential: userCredential);
  } catch (e) {
    return AuthResponse(errorMessage: e.toString());
  }
}


/// Function to get the currently logged-in user
User? getUser() {
  FirebaseAuth auth = FirebaseAuth.instance;
  return auth.currentUser;
}

/// Function to verify the user's MPIN
Future<String?> apiVerifyMPIN({
  required String? uid,
  required String mpinput,
}) async {
  if (uid == null) return null;

  try {
    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!documentSnapshot.exists) throw Exception("User not found");
    UserModel obj = UserModel.fromSnapshot(documentSnapshot);
    if (verifyMPIN(mpinput, obj.salt, obj.mpin)) return obj.name;

    return null;
  } catch (err) {
    return null;
  }
}


String firebaseAuthString(String code) {
  switch (code) {
    case "user-disabled":
      return "Your account is disabled!";
    case "user-not-found":
      return "User not found!";
    case "invalid-email":
    case "invalid-credential":
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Incorrect credentials!";
    case "too-many-requests":
      return "Too many requests. Try again later.";
    default:
      return "Something went wrong! Error code: $code";
  }
}
