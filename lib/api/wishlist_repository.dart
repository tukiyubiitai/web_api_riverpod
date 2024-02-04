import 'package:api_riverpod/wishlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// グローバルにアクセス可能なRepositoryProviderを定義します。
// これにより、WishlistRepositoryのインスタンスをアプリケーション全体で再利用できます。
final repositoryProvider = Provider.family<WishlistRepository,String>((_,applicationId) => WishlistRepository(applicationId),);

class WishlistRepository {
  WishlistRepository(this.applicationId);

  final String applicationId;

  // Dio HTTPクライアントを初期化します。ここでは、楽天APIへのリクエストに使用する基本設定を行います。
  // baseUrlにはAPIのベースURLを指定し、共通のクエリパラメータとしてapplicationIdを設定します。
  Dio get _client => Dio(
    BaseOptions(
      baseUrl: "https://app.rakuten.co.jp/services/api",
      queryParameters: {"applicationId": applicationId},
    ),
  );

  // 書籍データを非同期に取得するメソッドを定義します。
  // Dioクライアントを使用して、指定された条件で書籍の検索を行います。
  Future<List<Book>> getBooks() async {
    // APIからデータを取得します。リクエストパラメータには、キーワードやソート条件などを指定しています。
    final result = await _client.get("/BooksTotal/Search/20170404?&keyword=本&NGKeyword=予約&sort=sales&hits=20");

    // 取得したデータから"Items"キーに対応する部分を抽出し、List<dynamic>型として取り出します。
    final List<dynamic> items = result.data["Items"];

    // 抽出した各アイテムをBookオブジェクトに変換し、List<Book>として返します。
    // ここで、itemMap['Item']をMap<String, dynamic>型にキャストして、fromJsonコンストラクタに渡しています。
    return items.map<Book>((itemMap) => Book.fromJson(itemMap['Item'] as Map<String, dynamic>)).toList();
  }
}
