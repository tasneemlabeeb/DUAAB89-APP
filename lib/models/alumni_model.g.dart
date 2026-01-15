// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlumniModel _$AlumniModelFromJson(Map<String, dynamic> json) => AlumniModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      profile: json['profile'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AlumniModelToJson(AlumniModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'email': instance.email,
      'status': instance.status,
      'created_at': instance.createdAt,
      'profile': instance.profile,
    };
