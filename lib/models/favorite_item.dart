import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_item.freezed.dart';

//これから色々なAPIデータをお気に入りに追加できるようにするため

@freezed
class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    @Default("") String title,
    @Default("") String imageUrl,
    @Default("") String id,
    @Default("") String source,
  }) = _FavoriteItem;
}

@freezed
class FavoriteItemState with _$FavoriteItemState {
  const factory FavoriteItemState({
    @Default([]) List<FavoriteItem> favoriteItemList,
  }) = _FavoriteItemState;
}
