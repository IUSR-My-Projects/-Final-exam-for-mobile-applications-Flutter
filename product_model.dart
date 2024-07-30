class Product {
  late int? Id;
  late String title;
  late num price;
  late String description;
  late String image;
  late String category;

  Product(
      {required this.Id,
      required this.title,
      required this.price,
      required this.description,
      required this.image,
      required this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      Id: json['Id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      image: json['image'],
      category: json['category'],
    );
  }
}
