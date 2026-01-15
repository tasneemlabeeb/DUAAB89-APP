import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'events_repository.dart';
import '../../models/event_model.dart';

final eventsRepositoryProvider = Provider((ref) => EventsRepository());

final eventsListProvider = FutureProvider<List<EventModel>>((ref) async {
  final repo = ref.watch(eventsRepositoryProvider);
  return repo.fetchEventsAdmin();
});
