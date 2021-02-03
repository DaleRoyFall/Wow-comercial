class Product {
  int id;
  String title;
  String shortDescription;
  String image;
  int price;
  int salePrecent;
  String details;
  bool favorite;

  Product(
      {this.id,
      this.title,
      this.shortDescription,
      this.image,
      this.price,
      this.salePrecent,
      this.details,
      this.favorite});

  factory Product.fromJson(Map<String, dynamic> products) {
    return Product(
        id: products['id'],
        title: products['title'],
        shortDescription: products['short_description'],
        image: products['image'],
        price: products['price'],
        salePrecent: products['sale_precent'],
        details: products['details'],
        favorite: false);
  }

  Product copyWith(
      {int id,
      String title,
      String shortDescription,
      String image,
      int price,
      int salePrecent,
      String details,
      bool favorite}) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      image: image ?? this.image,
      price: price ?? this.price,
      salePrecent: salePrecent ?? this.salePrecent,
      details: details ?? this.details,
      favorite: favorite ?? this.favorite,
    );
  }
}
