import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/textstyle.dart';
import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/menu/menu_main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final ApiClient apicontroller = ApiClient();
  String selectedAddressForPickUp = "Выберите адрес ресторана";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Выберите адрес ресторана"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listOfAdressesForPickUp.length,
              itemBuilder: (BuildContext context, int index) {
                final address = listOfAdressesForPickUp[index]['address'] ?? '';
                final isEven = index % 2 == 0;
                final bgColor = isEven ? Colors.grey[200] : Colors.pink[50];

                return GestureDetector(
                  onTap: () async {
                    selectedAddressForPickUp = address;
                    apicontroller.setRestaurant(listOfAdressesForPickUp[index]['id'] ?? '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Menu(
                          TypeOfOrder: 2,
                          selectedAddressForPickUp: selectedAddressForPickUp,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.store, color: Colors.black54),
                      title: Text(address, style: TextStyle(fontSize: 16)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}