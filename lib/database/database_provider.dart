import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

import 'package:wow_comercial/database/dto/favorite_product_dto.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider getInstance = DBProvider._();

  // Database name
  static const String DATABASE_NAME = "WowComercial";

  // Tables name
  static const String FAVORITE_PRODUCT_TABLE_NAME = "favorite_product";

  // Favorite product table columns
  static const String ID = "id";
  static const String FAVORITE_PRODUCT_ID = "favorite_product_id";

  Database _database;
  // Init and return database
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = documentsDirectory.path + "/" + DATABASE_NAME + ".db";

    return await openDatabase(path, version: 1, onOpen: (database) {},
        onCreate: (Database database, int version) async {
      await createFavoritePorductTable(database);
    });
  }

  createFavoritePorductTable(Database database) {
    database.execute("CREATE TABLE " +
        FAVORITE_PRODUCT_TABLE_NAME +
        " (" +
        ID +
        " INTEGER PRIMARY KEY AUTOINCREMENT," +
        FAVORITE_PRODUCT_ID +
        " INTEGER NOT NULL"
            ")");
  }

  insertFavoriteProduct(FavoriteProductDTO favoriteProduct) async {
    final db = await database;
    var res =
        await db.insert(FAVORITE_PRODUCT_TABLE_NAME, favoriteProduct.toMap());
    return res;
  }

  Future<List<FavoriteProductDTO>> getFavoriteProducts() async {
    final db = await database;
    var res = await db.query(FAVORITE_PRODUCT_TABLE_NAME);
    return res.isNotEmpty
        ? res.map((c) => FavoriteProductDTO.fromJson(c)).toList()
        : [];
  }

  deleteFavoriteProduct(int favoriteProductId) async {
    final db = await database;
    var res = await db.delete(FAVORITE_PRODUCT_TABLE_NAME,
        where: FAVORITE_PRODUCT_ID + " = ?", whereArgs: [favoriteProductId]);
    return res;
  }

  deleteFavoritePorductTable() async {
    final db = await database;

    await db.execute("DROP TABLE IF EXISTS " + FAVORITE_PRODUCT_TABLE_NAME);
  }
}
