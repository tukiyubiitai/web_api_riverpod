import 'package:api_riverpod/wishlist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_state.freezed.dart';

@freezed
class WishlistState with _$WishlistState {
  const factory WishlistState({
    @Default([]) List<Book> books,
    @Default({}) Set<String> wishlist,
    @Default(LoadingState.progress) LoadingState loading,
  }) = _WishlistState;
}
