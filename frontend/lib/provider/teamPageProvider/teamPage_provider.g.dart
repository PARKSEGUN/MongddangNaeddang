// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamPage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTeamApiHash() => r'bc055e36b5e00340e5643d592577aebb74c372e2';

/// See also [getTeamApi].
@ProviderFor(getTeamApi)
final getTeamApiProvider = AutoDisposeProvider<TeamApiService>.internal(
  getTeamApi,
  name: r'getTeamApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getTeamApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetTeamApiRef = AutoDisposeProviderRef<TeamApiService>;
String _$teamLeaveHash() => r'37640d4289ef41574c9e5ef360cad66c9b81a170';

/// See also [teamLeave].
@ProviderFor(teamLeave)
final teamLeaveProvider = AutoDisposeFutureProvider<void>.internal(
  teamLeave,
  name: r'teamLeaveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$teamLeaveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TeamLeaveRef = AutoDisposeFutureProviderRef<void>;
String _$teamPageTeamInfoNotifierHash() =>
    r'a56c96a6507602a8c623f246f927367774e06470';

/// See also [TeamPageTeamInfoNotifier].
@ProviderFor(TeamPageTeamInfoNotifier)
final teamPageTeamInfoNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TeamPageTeamInfoNotifier, TeamPageTeamInfoModel>.internal(
  TeamPageTeamInfoNotifier.new,
  name: r'teamPageTeamInfoNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamPageTeamInfoNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TeamPageTeamInfoNotifier
    = AutoDisposeAsyncNotifier<TeamPageTeamInfoModel>;
String _$teamPageTeamMemberNotifierHash() =>
    r'555b6175efc88f9255ccf00af65df1112b789964';

/// See also [TeamPageTeamMemberNotifier].
@ProviderFor(TeamPageTeamMemberNotifier)
final teamPageTeamMemberNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TeamPageTeamMemberNotifier, List<TeamPageMemberModel>>.internal(
  TeamPageTeamMemberNotifier.new,
  name: r'teamPageTeamMemberNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamPageTeamMemberNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TeamPageTeamMemberNotifier
    = AutoDisposeAsyncNotifier<List<TeamPageMemberModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
