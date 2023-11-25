// ignore_for_file: constant_identifier_names

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:hive_flutter/hive_flutter.dart';

const FAVORITES_BOX_NAME = 'favorites';

abstract class FavoritesLocalDataSource {
  Future<List<Favorite>> getFavorites();

  Future<WriteSuccess> addFavorite(Favorite favorite);

  Future<WriteSuccess> removeFavorite(String id);

  Future<Favorite?> getFavoriteById(String id);
}

class FavoritesLocalDataSourceImpl extends FavoritesLocalDataSource {
  final HiveInterface interface;

  FavoritesLocalDataSourceImpl({required this.interface});

  @override
  Future<List<Favorite>> getFavorites() async {
    final favoritesBox = await _getOpenBox();
    return favoritesBox.values.toList();
  }

  @override
  Future<WriteSuccess> addFavorite(Favorite favorite) async {
    Box<Favorite> favoritesBox = await _getOpenBox();
    await favoritesBox.put(favorite.parentProdId, favorite);
    return const WriteSuccess();
  }

  @override
  Future<WriteSuccess> removeFavorite(String id) async {
    Box<Favorite> favoritesBox = await _getOpenBox();
    await favoritesBox.delete(id);
    return const WriteSuccess();
  }

  @override
  Future<Favorite?> getFavoriteById(String id) async {
    Box<Favorite> favoritesBox = await _getOpenBox();
    return favoritesBox.get(id);
  }

  Future<Box<Favorite>> _getOpenBox() async {
    try {
      late final Box<Favorite> hiveBox;
      hiveBox = await interface.openBox(Constants.FAVORITES_BOX_NAME);
      return hiveBox;
    } catch (e) {
      throw Exception(e);
    }
  }
}
