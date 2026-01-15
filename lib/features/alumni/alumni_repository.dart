import 'package:dio/dio.dart';
import '../../core/api/dio_client.dart';
import '../../models/alumni_model.dart';

class AlumniRepository {
  final Dio _dio = ApiClient().dio;

  Future<List<AlumniModel>> fetchAlumni() async {
    final resp = await _dio.get('/api/members');
    final data = resp.data as Map<String, dynamic>;
    final members = data['members'] as List<dynamic>? ?? [];
    return members.map((e) => AlumniModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<AlumniModel?> getAlumniById(String id) async {
    final list = await fetchAlumni();
    try {
      return list.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
