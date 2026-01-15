import 'package:json_annotation/json_annotation.dart';

part 'alumni_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AlumniModel {
  final String? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? email;
  final String? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final Map<String, dynamic>? profile;

  AlumniModel({this.id, this.userId, this.fullName, this.email, this.status, this.createdAt, this.profile});

  factory AlumniModel.fromJson(Map<String, dynamic> json) => _$AlumniModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlumniModelToJson(this);
}
