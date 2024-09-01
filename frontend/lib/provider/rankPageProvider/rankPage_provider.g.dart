// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rankPage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rankApiHash() => r'69de25d649e40f1368a769958ea7b0566abb4bae';

/// See also [rankApi].
@ProviderFor(rankApi)
final rankApiProvider = AutoDisposeProvider<RankApiService>.internal(
  rankApi,
  name: r'rankApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rankApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RankApiRef = AutoDisposeProviderRef<RankApiService>;
String _$teamAreaRankPageNotifierHash() =>
    r'9f8c997c9219ebbdbd207b02570a014a2fb48472';

/// See also [TeamAreaRankPageNotifier].
@ProviderFor(TeamAreaRankPageNotifier)
final teamAreaRankPageNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TeamAreaRankPageNotifier, List<RankPageModel>>.internal(
  TeamAreaRankPageNotifier.new,
  name: r'teamAreaRankPageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamAreaRankPageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TeamAreaRankPageNotifier
    = AutoDisposeAsyncNotifier<List<RankPageModel>>;
String _$teamDistRankPageNotifierHash() =>
    r'2c85b7b972ed2e4aed97fc06b5ba30652f99ac45';

/// See also [TeamDistRankPageNotifier].
@ProviderFor(TeamDistRankPageNotifier)
final teamDistRankPageNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TeamDistRankPageNotifier, List<RankPageModel>>.internal(
  TeamDistRankPageNotifier.new,
  name: r'teamDistRankPageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamDistRankPageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TeamDistRankPageNotifier
    = AutoDisposeAsyncNotifier<List<RankPageModel>>;
String _$userDistRankPageNotifierHash() =>
    r'a8b902139ba7e796ff19a39973711b6671ad471b';

/// See also [UserDistRankPageNotifier].
@ProviderFor(UserDistRankPageNotifier)
final userDistRankPageNotifierProvider = AutoDisposeAsyncNotifierProvider<
    UserDistRankPageNotifier, List<RankPageModel>>.internal(
  UserDistRankPageNotifier.new,
  name: r'userDistRankPageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userDistRankPageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserDistRankPageNotifier
    = AutoDisposeAsyncNotifier<List<RankPageModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
