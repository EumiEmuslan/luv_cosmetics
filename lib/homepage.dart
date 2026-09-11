import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'productmodel.dart';
import 'widgets/producttile.dart';
import 'widgets/productlist.dart';
import 'profile.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productsFuture;
  late Future<List<Product>> _newArrivalsFuture;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
    _newArrivalsFuture = fetchNewArrivals();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await Supabase.instance.client.from('products').select();
    final dataList = response as List<dynamic>;
    return dataList
        .map((p) => Product.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  Future<List<Product>> fetchNewArrivals() async {
    final response = await Supabase.instance.client
        .from('new_arrivals')
        .select();
    final dataList = response as List<dynamic>;
    return dataList
        .map((p) => Product.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "luv.cosmetics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () async {
              final products = await _productsFuture;
              final newArrivals = await _newArrivalsFuture;

              // Merge both lists
              final allItems = [...products, ...newArrivals];

              showSearch(
                context: context,
                delegate: ProductSearchDelegate(allItems),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),

      // Drawer with onDrawerChanged callback
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.deepOrange),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.deepOrange),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.deepOrange),
              title: const Text("Logout"),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      onDrawerChanged: (isOpen) {
        setState(() => _isDrawerOpen = isOpen);
      },

      // Animated body
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(_isDrawerOpen ? 200.0 : 0.0)
          ..scale(_isDrawerOpen ? 0.9 : 1.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepOrange, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Exclusive Deals\nUp to 50% Off!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.local_offer, color: Colors.white, size: 40),
                  ],
                ),
              ),

              // New Arrivals Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.deepOrange),
                    SizedBox(width: 8),
                    Text(
                      "New Arrivals",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              FutureBuilder<List<Product>>(
                future: _newArrivalsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading new arrivals"),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No new arrivals"));
                  }

                  final newArrivals = snapshot.data!;
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newArrivals.length,
                      itemBuilder: (context, index) {
                        final p = newArrivals[index];
                        return ProductTile(
                          imageUrl: p.imageUrl,
                          title: p.title,
                          description: p.description,
                          price: p.price,
                          oldPrice: p.oldPrice,
                          category: p.category,
                          createdAt: p.createdAt,
                        );
                      },
                    ),
                  );
                },
              ),

              // All Products Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag, color: Colors.deepOrange),
                    SizedBox(width: 8),
                    Text(
                      "All Products",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading products"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No products available"));
                  }

                  final products = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return ProductListTile(
                        imageUrl: p.imageUrl,
                        title: p.title,
                        description: p.description,
                        price: p.price,
                        oldPrice: p.oldPrice,
                        category: p.category,
                        createdAt: p.createdAt,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
