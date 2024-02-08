import 'dart:async';

import 'package:api_riverpod/providers/async_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wishlistAsyncNotifierProvider);
    Timer? _debounce;

    void _onSearchChanged(String value) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (value.isNotEmpty) {
          ref.read(wishlistAsyncNotifierProvider.notifier).searchBooks(value);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("検索ページ"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controller,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _onSearchChanged(value);
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.blue),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple.shade300),
                    ),
                    labelStyle: const TextStyle(color: Colors.deepPurple)),
              ),
            ),
            state.when(
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
                          //再読み込み
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
                shrinkWrap: true,
                // ここを追加
                physics: NeverScrollableScrollPhysics(),
                // ここを追加
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
                            final vm = ref
                                .read(wishlistAsyncNotifierProvider.notifier);
                            if (vm.isWishlisted(book.id)) {
                              vm.removeFromWishlist(book.id);
                            } else {
                              vm.addToWishlist(book);
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
          ],
        ),
      ),
    );
  }
}
