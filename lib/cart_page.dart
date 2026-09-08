import 'package:flutter/material.dart';
import 'cart_manager.dart';
import 'productmodel.dart';
import 'order_manager.dart';
import 'productdetailview.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool selectionMode = false;
  bool deleteMode = false;
  bool allSelected = false;

  @override
  void initState() {
    super.initState();
    CartManager.loadCart().then((_) {
      setState(() {});
    });
  }

  void toggleSelectAll() {
    setState(() {
      allSelected = !allSelected;
      for (var item in CartManager.items) {
        item.isSelected = allSelected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager.items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectionMode = !selectionMode;
                deleteMode = false;
                allSelected = false;
                for (var item in cartItems) {
                  item.isSelected = false;
                }
              });
            },
            child: Text(
              selectionMode ? "Cancel Select" : "Select",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                deleteMode = !deleteMode;
                selectionMode = false;
                allSelected = false;
                for (var item in cartItems) {
                  item.isSelected = false;
                }
              });
            },
            child: Text(
              deleteMode ? "Cancel Delete" : "Delete",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                if (selectionMode || deleteMode)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: toggleSelectAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(allSelected ? "Deselect All" : "Select All"),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final Product item = cartItems[index];
                      return InkWell(
                        onTap: () {
                          if (selectionMode || deleteMode) {
                            setState(() {
                              item.isSelected = !item.isSelected;
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailView(
                                  product: item,
                                  status: "In Cart",
                                  paymentMode: item.paymentMode,
                                ),
                              ),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: (selectionMode || deleteMode)
                                ? Checkbox(
                                    value: item.isSelected,
                                    onChanged: (val) {
                                      setState(() {
                                        item.isSelected = val ?? false;
                                      });
                                    },
                                  )
                                : const Icon(
                                    Icons.shopping_cart,
                                    color: Colors.deepOrange,
                                  ),
                            title: Text(item.title),
                            subtitle: Text("₱${item.price.toStringAsFixed(2)}"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.deepOrange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Selected Total: ₱${CartManager.selectedTotalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final selectedItems = CartManager.items
                    .where((item) => item.isSelected)
                    .toList();

                if (selectedItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No items selected")),
                  );
                  return;
                }

                if (deleteMode) {
                  setState(() {
                    for (var item in selectedItems) {
                      CartManager.remove(item);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Selected items deleted")),
                  );
                  return;
                }

                // Checkout flow using OrderManager helper
                showDialog(
                  context: context,
                  builder: (context) {
                    String? chosenMode;

                    return AlertDialog(
                      title: const Text("Select Payment Mode"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CheckboxListTile(
                            title: const Text("Online Payment"),
                            value: chosenMode == "Online",
                            onChanged: (val) {
                              chosenMode = "Online";
                              Navigator.pop(context);
                              OrderManager.proceedToOrders(
                                context,
                                selectedItems,
                                chosenMode!,
                              );
                              setState(() {
                                CartManager.clear();
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Cash on Delivery (COD)"),
                            value: chosenMode == "COD",
                            onChanged: (val) {
                              chosenMode = "COD";
                              Navigator.pop(context);
                              OrderManager.proceedToOrders(
                                context,
                                selectedItems,
                                chosenMode!,
                              );
                              setState(() {
                                CartManager.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: Text(deleteMode ? "Confirm Delete" : "Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
