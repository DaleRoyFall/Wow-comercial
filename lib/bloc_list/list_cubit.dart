import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/product.dart';
import '../helper/api_helper.dart';
import '../database/database_provider.dart';
import '../database/dto/favorite_product_dto.dart';

part 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(const ListState.loading());

  // Database variables
  DBProvider dbProvider;
  List<FavoriteProductDTO> favoriteProductList;

  // API variables
  String url = 'http://mobile-test.devebs.net:5000/products';
  int productCounter = 0;
  int productLimit = 10;

  Future<void> fetchList() async {
    if (dbProvider == null) {
      dbProvider = DBProvider.getInstance;
      await dbProvider.initDB();

      favoriteProductList = List<FavoriteProductDTO>();
      favoriteProductList = await dbProvider.getFavoriteProducts();
    }

    try {
      final productsFromApi =
          await getProducts(url, productCounter, productCounter + productLimit);

      if (productsFromApi != null) {
        if (productsFromApi.isNotEmpty) {
          productCounter += 10;
        } else {
          return;
        }

        productsFromApi.forEach((product) {
          if (favoriteProductList
              .where((element) => element.favoriteProductId == product.id)
              .isNotEmpty) {
            product.favorite = true;
          }
        });

        List<Product> productsToAdd = List<Product>();

        if (state.products.isNotEmpty) {
          productsToAdd.addAll(state.products);
        }
        productsToAdd.addAll(productsFromApi);

        emit(ListState.success(state.favorite, productsToAdd));
      } else {
        emit(const ListState.failure());
      }
    } on Exception {
      emit(const ListState.failure());
    }
  }

  Future<void> setFavoritePage(bool favorite) async {
    try {
      emit(ListState.favorite(favorite, state.products));
    } on Exception {
      emit(const ListState.failure());
    }
  }

  Future<void> setProductFavorite(int id) async {
    Product product = state.products.firstWhere((product) => product.id == id);
    if (product.favorite) {
      dbProvider.deleteFavoriteProduct(product.id);
    } else {
      dbProvider.insertFavoriteProduct(
          new FavoriteProductDTO(favoriteProductId: product.id));
    }

    final favoriteInProgress = state.products.map((product) {
      return product.id == id
          ? product.copyWith(favorite: !product.favorite)
          : product;
    }).toList();

    emit(ListState.success(state.favorite, favoriteInProgress));
  }

  void setStatus(ListStatus status) {
    ListState.setStatus(status, state.favorite, state.products);
  }
}
