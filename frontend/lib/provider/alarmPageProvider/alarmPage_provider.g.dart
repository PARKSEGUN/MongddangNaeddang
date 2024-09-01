// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarmPage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAlarmApiHash() => r'75c11c2004c4b110e56fdeaa7716b52b44c24c4d';

/// See also [getAlarmApi].
@ProviderFor(getAlarmApi)
final getAlarmApiProvider = AutoDisposeProvider<AlarmApiService>.internal(
  getAlarmApi,
  name: r'getAlarmApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAlarmApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAlarmApiRef = AutoDisposeProviderRef<AlarmApiService>;
String _$alarmListNotifierHash() => r'e2c34701a91545d4fd781b168ce9566a0c09b947';

/// See also [AlarmListNotifier].
@ProviderFor(AlarmListNotifier)
final alarmListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    AlarmListNotifier, List<AlarmModel>>.internal(
  AlarmListNotifier.new,
  name: r'alarmListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$alarmListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AlarmListNotifier = AutoDisposeAsyncNotifier<List<AlarmModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
