import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:api_riverpod/wishlist.dart';

final wishlistFutureProvider = FutureProvider<List<Book>>((ref) {
  final repository = ref.read(repositoryProvider);
  return repository.getBooks();
});