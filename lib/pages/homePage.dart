import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:miel_app/pages/Cart_page.dart';
import 'package:miel_app/pages/favorite_page.dart';
import 'package:miel_app/pages/product_details.dart';
import 'package:miel_app/services/product_service.dart'; // Assuming you have this import

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> products; // Fetch products

  // Pages for navigation
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Initialize the product list
  @override
  void initState() {
    super.initState();
    products = ProductService().getProducts(); // Fetch products from your service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discover the Sweet Honey text
            Text(
              'Discover the Sweet Honey',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Search Bar with rounded corners and light gray background
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(224, 241, 241, 241), // Light gray background
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for honey...',
                  border: InputBorder.none, // Remove the default border
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Most Popular Products Section
            Row(
              children: [
                Text(
                  'Most Popular Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 120),
                Text(
                  "See All",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade200,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Product List
            FutureBuilder<List<dynamic>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products available'));
                } else {
                  var productList = snapshot.data!;
                  return SizedBox(
                    height: 200, // Define fixed height for the product cards
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        var product = productList[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the product details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(product: product),
                              ),
                            );
                          },
                          child: Container(
                            width: 150,
                            margin: EdgeInsets.only(right: 10),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  product['image'] != null
                                      ? Image.network(
                                          'http://192.168.1.21:5000/${product['image']}',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.image, size: 80),
                                  SizedBox(height: 8),
                                  Text(
                                    product['name'] ?? 'No name',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${product['price'] ?? 0} TND',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              'Recommended',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.white,
        color: Colors.orange.shade300, // Color of the curved navigation bar
        items: const [
         CurvedNavigationBarItem(
          child: const Icon(Icons.home, color: Colors.white),
          label: 'Home', // Use String for the label
          labelStyle: TextStyle(
            color: Colors.white, // Set label color to white
            fontWeight: FontWeight.bold, // Make label text bold
          ),
        ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_cart, color: Colors.white),
            label: 'Cart',
             labelStyle: TextStyle(
            color: Colors.white, // Set label color to white
            fontWeight: FontWeight.bold, // Make label text bold
          ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.favorite, color: Colors.white),
            label: 'Favorite',
             labelStyle: TextStyle(
            color: Colors.white, // Set label color to white
            fontWeight: FontWeight.bold, // Make label text bold
          ),
          ),
        ],
       onTap: (index) {
    setState(() {
      _page = index;
    });

    // Navigate to corresponding page based on the selected index
    switch (index) {
      case 0:
        // Navigate to Home Page (or you can use a HomePage widget)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), 
        );
        break;
      case 1:
        // Navigate to Cart Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CartPage(cartItems: [],)),
        );
        break;
      case 2:
        // Navigate to Favorite Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavoritesPage()),
        );
        break;
    }
  },
      ),
    );
  }
}
