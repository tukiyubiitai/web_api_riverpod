import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//
class WishlistApp extends ConsumerWidget {
  const WishlistApp({required this.title,super.key});

   final String title;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
