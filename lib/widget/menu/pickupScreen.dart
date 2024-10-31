import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/textstyle.dart';
import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/menu/menu_main.dart';
import 'package:provider/provider.dart';

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
    // final addressProvider = Provider.of<CartProvider>(context, listen: false);
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
                return ListTile(
                  title: Text(listOfAdressesForPickUp[index]['address'] ?? ''),
                  onTap: () async {
                    // addressProvider.setAddressForPickUp(listOfAdressesForPickUp[index]['address'] ?? '');
                    selectedAddressForPickUp = listOfAdressesForPickUp[index]['address'] ?? '';
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}