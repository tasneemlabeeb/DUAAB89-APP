import 'package:dio/dio.dart';
import '../../core/api/dio_client.dart';
import '../../models/event_model.dart';

class EventsRepository {
  final Dio _dio = ApiClient().dio;

  /// Note: backend only exposes admin events endpoint (`/api/admin/events`) which requires an admin token.
  Future<List<EventModel>> fetchEventsAdmin() async {
    final resp = await _dio.get('/api/admin/events');
    final data = resp.data as Map<String, dynamic>;
    final events = data['events'] as List<dynamic>? ?? [];
    return events.map((e) => EventModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
