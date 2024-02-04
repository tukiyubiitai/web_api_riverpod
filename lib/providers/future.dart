import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:api_riverpod/wishlist.dart';

import '../api.dart';


///非同期に書籍リストを取得する
final wishlistFutureProvider = FutureProvider<List<Book>>((ref) {
  // ref.read()メソッドを使って、repositoryProviderが提供する現在の値（インスタンス）を読み取ります。
  final repository = ref.read(repositoryProvider(ApplicationId));
  // getBooksメソッドを呼び出して非同期に書籍データを取得し、
  // 取得したデータを<List<Book>>として返します。
  // この非同期処理の結果は、アプリケーションのUIで直接使用することができます。
  return repository.getBooks();
});