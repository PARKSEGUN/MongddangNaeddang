// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamGenPage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTeamGenApiHash() => r'5ff91022da14dac01092c0294010a43e16ee2552';

/// See also [getTeamGenApi].
@ProviderFor(getTeamGenApi)
final getTeamGenApiProvider = AutoDisposeProvider<TeamGenApiService>.internal(
  getTeamGenApi,
  name: r'getTeamGenApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTeamGenApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetTeamGenApiRef = AutoDisposeProviderRef<TeamGenApiService>;
String _$teamGenNotifierHash() => r'ff1233dfdf7003dfc5b6b19b54aa0d6d971c44c5';

/// See also [TeamGenNotifier].
@ProviderFor(TeamGenNotifier)
final teamGenNotifierProvider =
    AutoDisposeNotifierProvider<TeamGenNotifier, XFile?>.internal(
  TeamGenNotifier.new,
  name: r'teamGenNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamGenNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TeamGenNotifier = AutoDisposeNotifier<XFile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
