import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  final String? id;
  final String? title;
  final String? description;
  @JsonKey(name: 'event_date')
  final String? eventDate;
  @JsonKey(name: 'event_end_date')
  final String? eventEndDate;
  final String? location;
  @JsonKey(name: 'featured_image_url')
  final String? featuredImageUrl;
  final bool? published;

  EventModel({this.id, this.title, this.description, this.eventDate, this.eventEndDate, this.location, this.featuredImageUrl, this.published});

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
