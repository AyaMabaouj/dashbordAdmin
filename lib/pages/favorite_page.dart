import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favorites = [
    {
      'name': 'Honey Jar 1',
      'price': 20,
      'image': 'https://via.placeholder.com/80',
    },
    {
      'name': 'Honey Jar 2',
      'price': 25,
      'image': 'https://via.placeholder.com/80',
    },
  ];

  // Méthode pour supprimer un produit des favoris
  void _removeFromFavorites(int index) {
    setState(() {
      favorites.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text('No favorite products yet!'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  var favorite = favorites[index];

                  // Valeurs par défaut si null
                  String name = favorite['name'] ?? 'Unknown';
                  String image = favorite['image'] ?? 'https://via.placeholder.com/80';
                  String price = favorite['price']?.toString() ?? 'N/A';

                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: SizedBox(
                        width: 50, // Largeur de l'image
                        height: 50, // Hauteur de l'image
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Si l'image est chargée, on l'affiche normalement
                              return child;
                            } else {
                              // Pendant le chargement, on affiche un indicateur de chargement
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      title: Text(name),
                      subtitle: Text('$price TND'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeFromFavorites(index),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
