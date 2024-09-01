// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getUuidHash() => r'15371e970746384fd857cf6d347adb2789ffb8d8';

/// See also [getUuid].
@ProviderFor(getUuid)
final getUuidProvider = AutoDisposeFutureProvider<String?>.internal(
  getUuid,
  name: r'getUuidProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getUuidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetUuidRef = AutoDisposeFutureProviderRef<String?>;
String _$userNotifierHash() => r'c6d3d09365b0f1202815bd8f146335cb6abb0797';

/// See also [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider = NotifierProvider<UserNotifier, UserModel>.internal(
  UserNotifier.new,
  name: r'userNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserNotifier = Notifier<UserModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
