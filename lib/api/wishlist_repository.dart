import 'package:api_riverpod/wishlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final repositoryProvider = Provider<WishlistRepository>((_) => WishlistRepository(),);

class WishlistRepository{


  //Dioクライアントの設定
  final _client = Dio(
    BaseOptions(
      baseUrl: "https://app.rakuten.co.jp/services/api",
      queryParameters: {"applicationId": "1015330916483325363"},
    ),
  );

  //書籍データの取得
  Future<List<Book>> getBooks() async {
    final result = await _client.get("/BooksTotal/Search/20170404?&keyword=本&NGKeyword=予約&sort=sales&hits=20");
    final List<dynamic> items = result.data["Items"];
    return items.map<Book>((itemMap) => Book.fromJson(itemMap['Item'] as Map<String, dynamic>)).toList();
  }
}

