import 'package:json_annotation/json_annotation.dart';
import 'alumni_model.dart';

part 'alumni_list_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AlumniListResponse {
  final List<AlumniModel> members;
  final int? count;

  AlumniListResponse({required this.members, this.count});

  factory AlumniListResponse.fromJson(Map<String, dynamic> json) => _$AlumniListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AlumniListResponseToJson(this);
}
