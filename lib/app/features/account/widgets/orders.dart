import 'package:flutter/material.dart';
import '../../../constants/global_variables.dart';
import 'single_product.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  //Temporary List
  List list = [
    'https://m.media-amazon.com/images/I/41-RhQeujUL._AC_UF1000,1000_QL80_.jpg',
    'https://m.media-amazon.com/images/I/61mHMiZyW2L.jpg',
    'https://m.media-amazon.com/images/I/41al5-lNvML._AC_UF1000,1000_QL80_.jpg',
    'https://m.media-amazon.com/images/I/61Tn5a431IL._AC_UF894,1000_QL80_.jpg'
  ];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Text(
                'See all',
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ),
          ],
        ),
        // display orders
        Container(
            height: 170,
            padding: const EdgeInsets.only(
              left: 10,
              top: 20,
              right: 0,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return SingleProduct(image: list[index]);
                })),
      ],
    );
  }
}
