// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_count_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountInfo _$UnreadCountInfoFromJson(Map<String, dynamic> json) {
  return UnreadCountInfo(
    all: json['all'] as int,
    customTypes: (json['custom_types'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as num),
    ),
    ts: json['ts'] as int,
  );
}

Map<String, dynamic> _$UnreadCountInfoToJson(UnreadCountInfo instance) =>
    <String, dynamic>{
      'all': instance.all,
      'custom_types': instance.customTypes,
      'ts': instance.ts,
    };
