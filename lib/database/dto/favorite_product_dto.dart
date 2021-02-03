class FavoriteProductDTO {
  int id;
  int favoriteProductId;

  FavoriteProductDTO({this.id, this.favoriteProductId});

  factory FavoriteProductDTO.fromJson(Map<String, dynamic> json) =>
      new FavoriteProductDTO(
        id: json["id"],
        favoriteProductId: json["favorite_product_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "favorite_product_id": favoriteProductId,
      };
}
