import 'package:api_riverpod/api.dart';
import 'package:api_riverpod/wishlist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_notifier.g.dart';

//お気に入りの本を表示
@riverpod
List<Book> wishlistBooks(WishlistBooksRef ref) {
  try {
    final state = ref.watch(wishlistAsyncNotifierProvider).value;
    if (state == null) {
      return [];
    }
    return state.wishlist
        .map<Book>((id) => state.books.singleWhere((book) => book.id == id))
        .toList();
  } catch (e) {
    print(e);
    throw e;
  }
}

@riverpod
class WishlistAsyncNotifier extends _$WishlistAsyncNotifier {
  //api呼び出し
  WishlistRepository get _api => ref.read(repositoryProvider(ApplicationId));

  //buildメソッドは、AsyncNotifierの状態を初期化するために使用されます。
  // ここでは、書籍データの読み込みを行い、その結果を状態として設定します。
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

  // 追加データ取得
  Future<void> loadMoreBooks() async {
    try {
      //新しい値をnewBooks
      final newBooks = await _api.loadMoreBooks();
      if (newBooks.isEmpty) {
        // 新しい書籍データがない場合の処理
        return;
      }

      //既存のデータをcurrentStateに
      final currentState = state.value;
      if (currentState != null) {
        //既存のリストのコピー作成し、新しいリストに追加
        final updatedBooks = List<Book>.from(currentState.books)
          ..addAll(newBooks);
        state = AsyncValue.data(currentState.copyWith(books: updatedBooks));
      } else {
        // 何らかの理由で現在の状態がnullの場合は、新しいデータのみを設定します。
        state = AsyncValue.data(WishlistState(books: newBooks));
      }
    } catch (e) {
      // エラー処理
      print(e);
    }
  }

  //addToWishlistメソッドは、指定されたIDの書籍をウィッシュリストに追加します。
  void addToWishlist(Book book) {
    state = AsyncValue.data(state.value!.copyWith(
      wishlist: {...state.value!.wishlist, book.id},
    ));
  }

  // void addToFavoriteList(Book book) {
  //   final favoriteItem = FavoriteItem(
  //     title: book.title,
  //     imageUrl: book.imageUrl,
  //     id: book.id,
  //     source: "楽天API", // 例: "Google Books", "Open Library"など
  //   );
  //   //book.id, book.title, book.imageUrl
  //   ref
  //       .read(favoriteItemNotifierProvider.notifier)
  //       .addFavoriteItem(favoriteItem);
  // }

  //isWishlistedメソッドは、指定されたIDの書籍がウィッシュリストに含まれているかどうかを判定します。
  bool isWishlisted(String id) => state.value!.wishlist.contains(id);

  //removeFromWishlistメソッドは、指定されたIDの書籍をウィッシュリストから削除します。
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

  Future<void> searchBooks(String keyWords) async {
    try {
      final books = await _api.searchBooks(keyWords);
      // 現在の状態を取得（お気に入りリストを保持）
      final currentState = state.value;
      if (currentState != null) {
        // 既存のお気に入りリストを保持しながら、検索結果を書籍リストに追加
        state = AsyncValue.data(WishlistState(
          books: books,
          wishlist: currentState.wishlist, // お気に入りリストを維持
        ));
      } else {
        // 現在の状態がnullの場合（通常はあり得ないが、安全のため）
        state = AsyncValue.data(WishlistState(books: books));
      }
    } catch (e) {
      print(e);
    }
  }
}
