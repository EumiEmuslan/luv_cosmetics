class Product {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;
  final String category;
  final DateTime? createdAt;

  bool isSelected;
  String? paymentMode; // 👈 new field

  Product({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.category,
    this.createdAt,
    this.isSelected = false,
    this.paymentMode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      imageUrl: json['image_url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['old_price'] is int)
          ? (json['old_price'] as int).toDouble()
          : (json['old_price'] as num?)?.toDouble(),
      category: json['category'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      isSelected: json['is_selected'] ?? false,
      paymentMode: json['payment_mode'], // 👈 load if present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'title': title,
      'description': description,
      'price': price,
      'old_price': oldPrice,
      'category': category,
      'created_at': createdAt?.toIso8601String(),
      'is_selected': isSelected,
      'payment_mode': paymentMode, // 👈 save mode
    };
  }
}
