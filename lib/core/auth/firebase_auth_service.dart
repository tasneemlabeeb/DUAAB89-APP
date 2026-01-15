import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Authenticate with Firebase
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firebase authentication successful
      // Approval status check is handled by the UI via providers
      return credential;
    } on FirebaseAuthException catch (e) {
      // Firebase auth errors
      if (e.code == 'user-not-found') {
        throw Exception('No user found with this email address.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password. Please try again.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email address format.');
      } else if (e.code == 'user-disabled') {
        throw Exception('This account has been disabled.');
      } else if (e.code == 'too-many-requests') {
        throw Exception('Too many login attempts. Please try again later.');
      } else if (e.code == 'network-request-failed') {
        throw Exception('Network error. Please check your connection.');
      } else if (e.code == 'invalid-credential') {
        throw Exception(
            'Invalid credentials. Please check your email and password.');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
