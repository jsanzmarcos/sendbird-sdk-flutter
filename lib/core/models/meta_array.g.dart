// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_array.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageMetaArray _$MessageMetaArrayFromJson(Map<String, dynamic> json) {
  return MessageMetaArray(
    key: json['key'] as String,
    value: (json['value'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$MessageMetaArrayToJson(MessageMetaArray instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };
