import 'package:flutter/material.dart';
import '../product_detail.dart'; // 👈 make sure you create this file
import '../productmodel.dart';

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;
  final String category;
  final DateTime? createdAt;

  const ProductTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.category,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: Product(
                imageUrl: imageUrl,
                title: title,
                description: description,
                price: price,
                oldPrice: oldPrice,
                category: category,
                createdAt: createdAt,
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 180, // 👈 fixed width for carousel cards
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Price display
                    Row(
                      children: [
                        Text(
                          "₱${price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        if (oldPrice != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            "₱${oldPrice!.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),

                    if (createdAt != null)
                      Text(
                        "Added: ${createdAt!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
