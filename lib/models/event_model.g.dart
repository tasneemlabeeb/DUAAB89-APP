// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      eventDate: json['event_date'] as String?,
      eventEndDate: json['event_end_date'] as String?,
      location: json['location'] as String?,
      featuredImageUrl: json['featured_image_url'] as String?,
      published: json['published'] as bool?,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'event_date': instance.eventDate,
      'event_end_date': instance.eventEndDate,
      'location': instance.location,
      'featured_image_url': instance.featuredImageUrl,
      'published': instance.published,
    };
