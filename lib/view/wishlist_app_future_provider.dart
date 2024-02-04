import 'package:api_riverpod/providers/future.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class WishlistApp extends ConsumerWidget {
  const WishlistApp({required this.title,super.key});

   final String title;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final wishlist = ref.watch(wishlistFutureProvider);
    return  Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: wishlist.when(
          error:(e,stack)=>Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text("Problem loading books"),
                SizedBox(height: 10,),
                OutlinedButton(onPressed: (){

                }, child: Text("Try again"))
            ],),
          ),
        loading: ()=> Center(child: CircularProgressIndicator(),),
        data: (wishlist){
            return Text("Go response: ${wishlist.length}");
        },
      ),
    );
  }
}
