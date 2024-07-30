import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muhmad_omar_haj_hmdo/product_model.dart';
import 'package:muhmad_omar_haj_hmdo/product_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: const [
          Icon(Icons.notification_important_sharp),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Categories",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.blueAccent,
                    child: Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        final products = productProvider.products;
                        final categories = extractCategories(products);

                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (ctx, i) => Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      const Icon(Icons.category),
                                      Text(
                                        categories[i],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
          Expanded(
            flex: 2,
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final products = productProvider.products;

                if (products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) => ProductItem(products[i]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Provider.of<ProductProvider>(context, listen: false)
                .fetchProducts();
          });
        },
        child: const Icon(Icons.download),
      ),
    );
  }

  List<String> extractCategories(List<Product> products) {
    return products.map((product) => product.category).toSet().toList();
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('حذف منتج'),
            content: const Text('هل أنت متأكد من حذف المنتج'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  // Add your delete logic here
                  Navigator.of(ctx).pop();
                },
                child: const Text('حذف'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.purple[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              product.image,
              height: 50,
            ),
            Text(getFirstThreeWords(product.title)),
            Text((product.price).toString()),
            Text((product.price > 100 ? "10% off" : "").toString()),
          ],
        ),
      ),
    );
  }

  String getFirstThreeWords(String text) {
    List<String> words = text.split(' ');
    if (words.length > 3) {
      return '${words.sublist(0, 2).join(' ')}...';
    } else {
      return text;
    }
  }
}
