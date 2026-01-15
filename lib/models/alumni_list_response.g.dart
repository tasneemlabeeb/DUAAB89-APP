// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlumniListResponse _$AlumniListResponseFromJson(Map<String, dynamic> json) =>
    AlumniListResponse(
      members: (json['members'] as List<dynamic>)
          .map((e) => AlumniModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AlumniListResponseToJson(AlumniListResponse instance) =>
    <String, dynamic>{
      'members': instance.members.map((e) => e.toJson()).toList(),
      'count': instance.count,
    };
