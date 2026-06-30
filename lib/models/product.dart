class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final int stock;
  final int discount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.stock,
    required this.discount,
  });

  double get discountAmount {
    return price * discount / 100;
  }

  double get finalPrice {
    return price - discountAmount;
  }

  bool get hasDiscount {
    return discount > 0;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final int id = json['id'];

    return Product(
      id: id,
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],

      // Stok simulasi karena API tidak menyediakan stok
      stock: 10 + id,

      // Diskon simulasi:
      // produk dengan ID genap dapat diskon 10%, ID ganjil tidak diskon
      discount: id % 2 == 0 ? 10 : 0,
    );
  }
}