import 'package:api_riverpod/providers/async_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistedView extends ConsumerWidget {
  const WishlistedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlisted = ref.watch(wishlistBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("お気に入りリスト"),
      ),
      body: wishlisted.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("お気に入りリストが空です"),
                  SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("本を追加して下さい"))
                ],
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: wishlisted.length,
              itemBuilder: (context, index) {
                final book = wishlisted[index];
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
                              wishlisted[index].title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                          child: InkWell(
                        onTap: () {
                          final vm =
                              ref.read(wishlistAsyncNotifierProvider.notifier);
                          vm.removeFromWishlist(book.id);
                        },
                        child: Align(
                          child: Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 50,
                          ),
                        ),
                      ))
                    ],
                  ),
                );
              },
            ),
    );
  }
}
