import 'package:api_riverpod/providers/state_notifier.dart';
import 'package:api_riverpod/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///api呼び出しを実行する必要があるから、ConsumerStatefulでinitStateでapiを呼び出し処理する
class WishlistStateNotifierApp extends ConsumerStatefulWidget {
  const WishlistStateNotifierApp({required this.title, super.key});

  final String title;

  @override
  ConsumerState<WishlistStateNotifierApp> createState() =>
      _WishlistCNProviderAppState();
}

class _WishlistCNProviderAppState
    extends ConsumerState<WishlistStateNotifierApp> {
  @override
  void initState() {
    super.initState();
    //データのロード
    ref.read(wishlistStateProvider.notifier).loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = ref.watch(wishlistStateProvider);
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
                            ref
                                .read(wishlistStateProvider.notifier)
                                .reloadBooks();
                          },
                          child: Text("Try again"))
                    ],
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: wishlist.books.length,
                  itemBuilder: (context, index) {
                    final book = wishlist.books[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              book.imageUrl,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.grey,
                                  ],
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  wishlist.books[index].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
