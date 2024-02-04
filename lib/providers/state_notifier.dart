import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../wishlist.dart';

/*
freezedを使うことで、
不変の状態を持つデータクラスを簡単に定義し、
その状態をStateNotifierを通じて更新することができます。
 */

final wishlistStateProvider =
    StateNotifierProvider<WishlistStateNotifier, WishlistState>(
        (ref) => WishlistStateNotifier(ref));

class WishlistStateNotifier extends StateNotifier<WishlistState> {
  WishlistStateNotifier(Ref ref)
      : _api = ref.read(repositoryProvider(ApplicationId)),
        super(const WishlistState());

  final WishlistRepository _api;

  // 書籍データを再読み込みするメソッドです。読み込み状態をprogressに設定してから、書籍データの読み込みを開始します。
  Future<void> reloadBooks() async {
    state = state.copyWith(
      loading: LoadingState.progress,
    );
    loadBooks();
  }

  // APIから書籍データを非同期に読み込むメソッドです。
  Future<void> loadBooks() async {
    try {
      // APIから書籍データを取得します。成功した場合、取得したデータをbooksリストに追加します。
      final response = await _api.getBooks();
      state = state.copyWith(books: response, loading: LoadingState.success);
    } catch (_) {
      // エラーが発生した場合、読み込み状態をerrorに更新します。
      state = state.copyWith(loading: LoadingState.error);
    }
  }
}
