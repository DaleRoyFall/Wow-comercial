part of 'list_cubit.dart';

enum ListStatus { loading, success, failure }

class ListState extends Equatable {
  const ListState._({
    this.status = ListStatus.loading,
    this.favorite = false,
    this.products = const <Product>[],
  });

  const ListState.loading() : this._();

  const ListState.favorite(bool favorite, List<Product> products)
      : this._(
            status: ListStatus.success, favorite: favorite, products: products);

  const ListState.success(bool favorite, List<Product> products)
      : this._(
            status: ListStatus.success, favorite: favorite, products: products);

  const ListState.setStatus(
      ListStatus status, bool favorite, List<Product> products)
      : this._(status: status, favorite: favorite, products: products);

  const ListState.failure() : this._(status: ListStatus.failure);

  final ListStatus status;
  final bool favorite;
  final List<Product> products;

  @override
  List<Object> get props => [status, favorite, products];
}
