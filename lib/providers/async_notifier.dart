import 'package:api_riverpod/api.dart';
import 'package:api_riverpod/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistAsyncNotifierProvider =
    AsyncNotifierProvider<WishlistAsyncNotifier, WishlistState>(
        () => WishlistAsyncNotifier());

class WishlistAsyncNotifier extends AsyncNotifier<WishlistState> {
  WishlistRepository get _api => ref.read(repositoryProvider(ApplicationId));

  @override
  Future<WishlistState> build() => _loadBooks();

  Future<WishlistState> _loadBooks() async {
    final response = await _api.getBooks();
    return WishlistState(books: response);
  }

  // 書籍データを再読み込みするメソッドです。読み込み状態をprogressに設定してから、書籍データの読み込みを開始します。
  Future<void> reloadBooks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadBooks());
  }

  void addToWishlist(String id) {
    state = AsyncValue.data(state.value!.copyWith(
      wishlist: {...state.value!.wishlist, id},
    ));
  }

  bool isWishlisted(String id) => state.value!.wishlist.contains(id);

  // void removeFromWishlist(String id) {
  //   try {
  //     state = AsyncValue.data(state.value!.copyWith(
  //       wishlist: {...state.value!.wishlist..remove(id)},
  //     ));
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  void removeFromWishlist(String id) {
    try {
      // 変更可能なセットのコピーを作成
      final Set<String> newWishlist = Set.from(state.value!.wishlist);
      // コピーに対して要素を削除
      newWishlist.remove(id);
      // 状態を更新
      state = AsyncValue.data(state.value!.copyWith(
        wishlist: newWishlist,
      ));
    } catch (e) {
      print(e);
    }
  }
}
