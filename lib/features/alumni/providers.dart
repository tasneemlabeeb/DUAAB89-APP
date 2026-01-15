import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'alumni_repository.dart';
import '../../models/alumni_model.dart';

final alumniRepositoryProvider = Provider((ref) => AlumniRepository());

final alumniListProvider = FutureProvider<List<AlumniModel>>((ref) async {
  final repo = ref.watch(alumniRepositoryProvider);
  return repo.fetchAlumni();
});

final alumniDetailProvider = FutureProvider.family<AlumniModel?, String>((ref, id) async {
  final repo = ref.watch(alumniRepositoryProvider);
  return repo.getAlumniById(id);
});
