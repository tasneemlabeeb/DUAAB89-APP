import 'firebase_auth_service.dart';

class TokenProvider {
  final FirebaseAuthService _authService = FirebaseAuthService();

  /// returns Firebase ID token if user is logged in, else null
  Future<String?> getIdToken() async {
    return await _authService.getIdToken();
  }
}
