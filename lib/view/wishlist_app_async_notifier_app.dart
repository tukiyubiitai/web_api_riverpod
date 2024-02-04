import 'package:api_riverpod/providers/async_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistAsyncNotifierApp extends ConsumerStatefulWidget {
  const WishlistAsyncNotifierApp({required this.title, super.key});

  final String title;

  @override
  ConsumerState<WishlistAsyncNotifierApp> createState() =>
      _WishlistAsyncNotifierAppState();
}

class _WishlistAsyncNotifierAppState
    extends ConsumerState<WishlistAsyncNotifierApp> {
  @override
  Widget build(BuildContext context) {
    final wishlist = ref.watch(wishlistAsyncNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: wishlist.when(
        error: (e, stack) => Center(
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
                    ref
                        .read(wishlistAsyncNotifierProvider.notifier)
                        .reloadBooks();
                  },
                  child: Text("Try again"))
            ],
          ),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        data: (data) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: data.books.length,
          itemBuilder: (context, index) {
            final book = data.books[index];
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
                          data.books[index].title,
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
                      if (vm.isWishlisted(book.id)) {
                        vm.removeFromWishlist(book.id);
                      } else {
                        vm.addToWishlist(book.id);
                      }
                    },
                    child: Align(
                      child: Icon(
                        Icons.favorite,
                        color: data.wishlist.contains(book.id)
                            ? Colors.redAccent
                            : Colors.black38,
                        size: 50,
                      ),
                    ),
                  ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
