import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.description),
      trailing: Text('\$${product.price}'),
      onTap: () {
        // Naviguer vers la page de détails du produit si nécessaire
      },
    );
  }
}
