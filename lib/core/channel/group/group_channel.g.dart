// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupChannel _$GroupChannelFromJson(Map<String, dynamic> json) {
  return GroupChannel(
    lastMessage: json['last_message'] == null
        ? null
        : BaseMessage.fromJson(json['last_message'] as Map<String, dynamic>),
    isSuper: json['is_super'] as bool,
    isStrict: json['is_strict'] as bool ?? false,
    isBroadcast: json['is_broadcast'] as bool,
    isPublic: json['is_public'] as bool,
    isDistinct: json['is_distinct'] as bool,
    isDiscoverable: json['is_discoverable'] as bool,
    accessCodeRequired: json['access_code_required'] as bool,
    unreadMessageCount: json['unread_message_count'] as int,
    unreadMentionCount: json['unread_mention_count'] as int,
    members: (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    memberCount: json['member_count'] as int,
    joinedMemberCount: json['joined_member_count'] as int,
    myPushTriggerOption: _$enumDecodeNullable(
        _$GroupChannelPushTriggerOptionEnumMap, json['push_trigger_option']),
    myMemberState:
        _$enumDecodeNullable(_$MemberStateEnumMap, json['member_state']),
    myRole: _$enumDecodeNullable(_$RoleEnumMap, json['my_role'],
        unknownValue: Role.none),
    myMutedState: booltoMuteState(json['is_muted'] as bool),
    myCountPreference: _$enumDecodeNullable(
        _$CountPreferenceEnumMap, json['count_preference']),
    invitedAt: json['invited_at'] as int,
    isHidden: json['is_hidden'] as bool,
    hiddenState: _$enumDecodeNullable(
        _$GroupChannelHiddenStateEnumMap, json['hidden_state']),
    myLastRead: json['user_last_read'] as int,
    messageOffsetTimestamp: json['ts_message_offset'] as int,
    messageSurvivalSeconds: json['message_survival_seconds'] as int,
    channelUrl: json['channel_url'] as String,
    name: json['name'] as String,
    coverUrl: json['cover_url'] as String,
    creator: json['creator'] == null
        ? null
        : User.fromJson(json['creator'] as Map<String, dynamic>),
    createdAt: json['created_at'] as int,
    data: json['data'] as String,
    customType: json['custom_type'] as String,
    isFrozen: json['freeze'] as bool,
    isEphemeral: json['is_ephemeral'] as bool,
  )..inviter = json['inviter'] == null
      ? null
      : Member.fromJson(json['inviter'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GroupChannelToJson(GroupChannel instance) =>
    <String, dynamic>{
      'channel_url': instance.channelUrl,
      'name': instance.name,
      'cover_url': instance.coverUrl,
      'creator': instance.creator?.toJson(),
      'created_at': instance.createdAt,
      'data': instance.data,
      'custom_type': instance.customType,
      'freeze': instance.isFrozen,
      'is_ephemeral': instance.isEphemeral,
      'last_message': instance.lastMessage?.toJson(),
      'is_super': instance.isSuper,
      'is_strict': instance.isStrict,
      'is_broadcast': instance.isBroadcast,
      'is_public': instance.isPublic,
      'is_distinct': instance.isDistinct,
      'is_discoverable': instance.isDiscoverable,
      'access_code_required': instance.accessCodeRequired,
      'unread_message_count': instance.unreadMessageCount,
      'unread_mention_count': instance.unreadMentionCount,
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'member_count': instance.memberCount,
      'joined_member_count': instance.joinedMemberCount,
      'push_trigger_option':
          _$GroupChannelPushTriggerOptionEnumMap[instance.myPushTriggerOption],
      'member_state': _$MemberStateEnumMap[instance.myMemberState],
      'my_role': _$RoleEnumMap[instance.myRole],
      'is_muted': _$MuteStateEnumMap[instance.myMutedState],
      'count_preference': _$CountPreferenceEnumMap[instance.myCountPreference],
      'inviter': instance.inviter?.toJson(),
      'invited_at': instance.invitedAt,
      'is_hidden': instance.isHidden,
      'hidden_state': _$GroupChannelHiddenStateEnumMap[instance.hiddenState],
      'user_last_read': instance.myLastRead,
      'ts_message_offset': instance.messageOffsetTimestamp,
      'message_survival_seconds': instance.messageSurvivalSeconds,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$GroupChannelPushTriggerOptionEnumMap = {
  GroupChannelPushTriggerOption.global: 'default',
  GroupChannelPushTriggerOption.all: 'all',
  GroupChannelPushTriggerOption.off: 'off',
  GroupChannelPushTriggerOption.mentionOnly: 'mention_only',
};

const _$MemberStateEnumMap = {
  MemberState.none: 'none',
  MemberState.invited: 'invited',
  MemberState.joined: 'joined',
};

const _$RoleEnumMap = {
  Role.none: 'none',
  Role.chat_operator: 'operator',
};

const _$CountPreferenceEnumMap = {
  CountPreference.all: 'all',
  CountPreference.messageOnly: 'unread_message_count_only',
  CountPreference.mentionOnly: 'unread_mention_count_only',
  CountPreference.off: 'off',
};

const _$GroupChannelHiddenStateEnumMap = {
  GroupChannelHiddenState.unhidden: 'unhidden',
  GroupChannelHiddenState.allowAutoUnhide: 'allow_auto_unhide',
  GroupChannelHiddenState.preventAutoUnhide: 'prevent_auto_unhide',
};

const _$MuteStateEnumMap = {
  MuteState.unmuted: 'unmuted',
  MuteState.muted: 'muted',
};
