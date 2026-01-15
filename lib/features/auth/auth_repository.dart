import 'package:firebase_auth/firebase_auth.dart';
import '../../core/auth/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _service = FirebaseAuthService();

  Stream<User?> authStateChanges() => _service.authStateChanges();
  User? get currentUser => _service.currentUser;

  Future<UserCredential> signIn({required String email, required String password}) async {
    return await _service.signInWithEmail(email: email, password: password);
  }

  Future<void> signOut() async {
    return await _service.signOut();
  }
}
