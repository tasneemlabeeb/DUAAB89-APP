import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class AlumniDetailScreen extends ConsumerWidget {
  final String alumniId;
  const AlumniDetailScreen({super.key, required this.alumniId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(alumniDetailProvider(alumniId));

    return Scaffold(
      body: SafeArea(
        child: async.when(
          data: (alumni) {
            if (alumni == null) return const Center(child: Text('Not found'));
            final avatarUrl = alumni.profile?['profilePhotoUrl'] as String?;
            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                        backgroundColor: Colors.white24,
                        child: avatarUrl == null ? Text((alumni.fullName ?? 'U').substring(0, 1), style: const TextStyle(color: Colors.white, fontSize: 24)) : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alumni.fullName ?? 'No name', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(alumni.email ?? '', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // Basic info cards
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  Text('Status: ${alumni.status ?? 'N/A'}'),
                                  const SizedBox(height: 6),
                                  Text('Joined: ${alumni.createdAt ?? 'N/A'}'),
                                  const SizedBox(height: 8),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  Text(alumni.profile?.toString() ?? 'No profile details available.'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.email_outlined),
                                  label: const Text('Message'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.phone_outlined),
                                  label: const Text('Call'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
