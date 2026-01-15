import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/providers.dart';
import 'features/auth/pending_approval_screen.dart';
import 'features/auth/rejected_account_screen.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DUAAB89',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final approvalStatus = ref.watch(userApprovalStatusProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        // User is signed in, check approval status
        return approvalStatus.when(
          data: (status) {
            if (status == 'approved') {
              return const DashboardScreen();
            } else if (status == 'pending') {
              return const PendingApprovalScreen();
            } else if (status == 'rejected') {
              return const RejectedAccountScreen();
            } else {
              // Unknown status, show login
              return const LoginScreen();
            }
          },
          loading: () => Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
              ),
            ),
          ),
          error: (error, stack) => const LoginScreen(),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
          ),
        ),
      ),
      error: (error, stack) => const LoginScreen(),
    );
  }
}
