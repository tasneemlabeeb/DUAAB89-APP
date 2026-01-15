import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/auth/firebase_auth_service.dart';
import 'auth_repository.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());
final firebaseAuthServiceProvider =
    Provider<FirebaseAuthService>((ref) => FirebaseAuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  final svc = ref.watch(firebaseAuthServiceProvider);
  return svc.authStateChanges();
});

// Monitor user approval status in real-time
final userApprovalStatusProvider = StreamProvider<String?>((ref) {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  return auth.authStateChanges().asyncMap((user) async {
    if (user == null) {
      print('👤 User is null, returning null status');
      return null;
    }

    print('👤 Checking approval status for user: ${user.uid} (${user.email})');

    try {
      // First try 'users' collection (new structure)
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final status = userDoc.data()?['approval_status'] as String?;
        print('✅ Found in users collection - approval_status: $status');
        print('📄 Full user data: ${userDoc.data()}');
        return status;
      } else {
        print('⚠️  User document not found in users collection');
      }

      // Fallback to 'members' collection (old structure)
      final memberDoc =
          await firestore.collection('members').doc(user.uid).get();

      if (memberDoc.exists) {
        final status = memberDoc.data()?['status'] as String?;
        print('✅ Found in members collection - status: $status');
        print('📄 Full member data: ${memberDoc.data()}');
        return status;
      } else {
        print('⚠️  User document not found in members collection either');
      }

      print('❌ No profile found in either collection for user ${user.uid}');
      return null;
    } catch (e) {
      print('❌ Error fetching approval status: $e');
      return null;
    }
  }).asBroadcastStream();
});

// Check if user is approved
final isUserApprovedProvider = StreamProvider<bool>((ref) async* {
  final status = ref.watch(userApprovalStatusProvider);

  yield* status.when(
    data: (approvalStatus) => Stream.value(approvalStatus == 'approved'),
    loading: () => Stream.value(false),
    error: (error, stack) => Stream.value(false),
  );
});
