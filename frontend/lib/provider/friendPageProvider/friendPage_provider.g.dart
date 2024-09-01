// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendPage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getFriendApiHash() => r'e6439a3aa56ac0ae9ef623ffb491fed871326470';

/// See also [getFriendApi].
@ProviderFor(getFriendApi)
final getFriendApiProvider = AutoDisposeProvider<FriendApiService>.internal(
  getFriendApi,
  name: r'getFriendApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getFriendApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetFriendApiRef = AutoDisposeProviderRef<FriendApiService>;
String _$friendListNotifierHash() =>
    r'7acf66f45165c10018f4357d932c83cbf8685787';

/// See also [FriendListNotifier].
@ProviderFor(FriendListNotifier)
final friendListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    FriendListNotifier, List<FriendPageModel>>.internal(
  FriendListNotifier.new,
  name: r'friendListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendListNotifier = AutoDisposeAsyncNotifier<List<FriendPageModel>>;
String _$searchFriendNotifierHash() =>
    r'a77534efabb390f819b8de0025408a4a25ecfb36';

/// See also [SearchFriendNotifier].
@ProviderFor(SearchFriendNotifier)
final searchFriendNotifierProvider = AutoDisposeNotifierProvider<
    SearchFriendNotifier, AsyncValue<FriendPageModel>?>.internal(
  SearchFriendNotifier.new,
  name: r'searchFriendNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchFriendNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchFriendNotifier
    = AutoDisposeNotifier<AsyncValue<FriendPageModel>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
