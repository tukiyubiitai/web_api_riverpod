import 'package:api_riverpod/providers/change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///api呼び出しを実行する必要があるから、ConsumerStatefulでinitStateでapiを呼び出し処理する
class WishlistChangeNotifierApp extends ConsumerStatefulWidget {
  const WishlistChangeNotifierApp({required this.title, super.key});

  final String title;

  @override
  ConsumerState<WishlistChangeNotifierApp> createState() =>
      _WishlistCNProviderAppState();
}

class _WishlistCNProviderAppState
    extends ConsumerState<WishlistChangeNotifierApp> {
  @override
  void initState() {
    super.initState();
    //データのロード
    ref.read(wishlistCNProvider).loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = ref.watch(wishlistCNProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: wishlist.loading == LoadingState.progress
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : wishlist.loading == LoadingState.error
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Problem loading books"),
                      SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            // 書籍データを再読み込みする
                            ref.read(wishlistCNProvider).reloadBooks();
                          },
                          child: Text("Try again"))
                    ],
                  ),
                )
              : Text("Got response: ${wishlist.books.length}"),
    );
  }
}
