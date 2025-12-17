import 'package:flutter/foundation.dart';

class FavoriteHotel {
  final String name;
  final String location;
  final String price;
  final String imagePath;

  const FavoriteHotel({
    required this.name,
    required this.location,
    required this.price,
    required this.imagePath,
  });
}

class FavoritesManager {
  FavoritesManager._();

  static final ValueNotifier<List<FavoriteHotel>> favoritesNotifier =
      ValueNotifier<List<FavoriteHotel>>([]);

  static bool isFavorite(String name) {
    return favoritesNotifier.value.any((hotel) => hotel.name == name);
  }

  static void toggleFavorite(FavoriteHotel hotel) {
    final current = List<FavoriteHotel>.from(favoritesNotifier.value);
    final existingIndex =
        current.indexWhere((element) => element.name == hotel.name);
    if (existingIndex != -1) {
      current.removeAt(existingIndex);
    } else {
      current.add(hotel);
    }
    favoritesNotifier.value = current;
  }
}


