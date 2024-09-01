// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamSearchPage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getSearchApiHash() => r'55681801289cd097161bf7379513e52c477b3156';

/// See also [getSearchApi].
@ProviderFor(getSearchApi)
final getSearchApiProvider = Provider<TeamSearchApiService>.internal(
  getSearchApi,
  name: r'getSearchApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getSearchApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetSearchApiRef = ProviderRef<TeamSearchApiService>;
String _$signUpTeamHash() => r'3aa9285ff36748642295364b893e994773ef18d4';

/// See also [signUpTeam].
@ProviderFor(signUpTeam)
final signUpTeamProvider = AutoDisposeFutureProvider<void>.internal(
  signUpTeam,
  name: r'signUpTeamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signUpTeamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignUpTeamRef = AutoDisposeFutureProviderRef<void>;
String _$searchedTeamNameNotifierHash() =>
    r'6f8d837c5a0f3f799d5c22e9714cf4947a2f8020';

/// See also [SearchedTeamNameNotifier].
@ProviderFor(SearchedTeamNameNotifier)
final searchedTeamNameNotifierProvider =
    AutoDisposeNotifierProvider<SearchedTeamNameNotifier, String>.internal(
  SearchedTeamNameNotifier.new,
  name: r'searchedTeamNameNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedTeamNameNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchedTeamNameNotifier = AutoDisposeNotifier<String>;
String _$sortTypeNotifierHash() => r'6e6f804527e38a854dfadd872a4c450f83fa0376';

/// See also [SortTypeNotifier].
@ProviderFor(SortTypeNotifier)
final sortTypeNotifierProvider =
    AutoDisposeNotifierProvider<SortTypeNotifier, int>.internal(
  SortTypeNotifier.new,
  name: r'sortTypeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sortTypeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SortTypeNotifier = AutoDisposeNotifier<int>;
String _$togglePossibleTeamNotifierHash() =>
    r'afcc855d4bcac895fe340913159d079bf9dfa8eb';

/// See also [TogglePossibleTeamNotifier].
@ProviderFor(TogglePossibleTeamNotifier)
final togglePossibleTeamNotifierProvider =
    AutoDisposeNotifierProvider<TogglePossibleTeamNotifier, bool>.internal(
  TogglePossibleTeamNotifier.new,
  name: r'togglePossibleTeamNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$togglePossibleTeamNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TogglePossibleTeamNotifier = AutoDisposeNotifier<bool>;
String _$searchTeamListBySortTypeNotifierHash() =>
    r'6ece425a55185de964aea1187d7daa1e86fe2d42';

/// See also [SearchTeamListBySortTypeNotifier].
@ProviderFor(SearchTeamListBySortTypeNotifier)
final searchTeamListBySortTypeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SearchTeamListBySortTypeNotifier,
        List<List<SearchPageTeamModel>>>.internal(
  SearchTeamListBySortTypeNotifier.new,
  name: r'searchTeamListBySortTypeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchTeamListBySortTypeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchTeamListBySortTypeNotifier
    = AutoDisposeAsyncNotifier<List<List<SearchPageTeamModel>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
