import 'package:api_riverpod/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

// APIから書籍データを取得するために使用するリポジトリのプロバイダーを定義します。
final wishlistCNProvider =
    ChangeNotifierProvider((ref) => WishlistChangeNotifier(ref));

// 非同期処理の状態を表す列挙体です。読み込み中、成功、エラーの3状態があります。
enum LoadingState { progress, success, error }

// 書籍リストの状態を管理するためのChangeNotifierクラスです。
class WishlistChangeNotifier extends ChangeNotifier {
  // コンストラクタ。repositoryProviderを介してAPIへのアクセスを設定します。
  WishlistChangeNotifier(Ref ref)
      : _api = ref.read(repositoryProvider(ApplicationId));

  // WishlistRepositoryインスタンス。API操作を担当します。
  final WishlistRepository _api;

  // 現在の読み込み状態を保持します。初期状態は`progress`です。
  LoadingState loading = LoadingState.progress;

  // 書籍データのリストを保持する変数です。
  final books = <Book>[];

  // 書籍データを再読み込みするメソッドです。読み込み状態をprogressに設定してから、書籍データの読み込みを開始します。
  void reloadBooks() {
    loading = LoadingState.progress;
    notifyListeners(); // UIに状態変更を通知します。
    loadBooks(); // 書籍データの読み込みを開始します。
  }

  // APIから書籍データを非同期に読み込むメソッドです。
  Future<void> loadBooks() async {
    try {
      // throw "test_error";
      // APIから書籍データを取得します。成功した場合、取得したデータをbooksリストに追加します。
      final response = await _api.getBooks();
      books.addAll(response);
      loading = LoadingState.success; // 読み込み成功を表す状態に更新します。
    } catch (_) {
      // エラーが発生した場合、読み込み状態をerrorに更新します。
      loading = LoadingState.error;
    }
    notifyListeners(); // UIに状態変更を通知します。
  }
}
