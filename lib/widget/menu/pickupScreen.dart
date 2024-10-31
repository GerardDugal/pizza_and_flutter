// import 'package:flutter/material.dart';
// import 'package:pizza_and_flutter/api_clients/api_client.dart';
// import 'package:pizza_and_flutter/textstyle.dart';
// import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
// import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
// import 'package:pizza_and_flutter/widget/menu/menu.dart';
// import 'package:provider/provider.dart';

// class PickupScreen extends StatefulWidget {
//   const PickupScreen({super.key});

//   @override
//   State<PickupScreen> createState() => _PickupScreenState();
// }

// class _PickupScreenState extends State<PickupScreen> {
//   final ApiClient apicontroller = ApiClient();
  
//   void clearMenu(){
//     for (var element in categorizedMenu) {
//       element['items'] = [];
//     }
//     for (var element in listOfAdditionalMenu) {
//       element['items'] = <Map<String, int>>[];
//     }
//     setState(() {
      
//     });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final addressProvider = Provider.of<CartProvider>(context, listen: false); // Получаем провайдер
//     return Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Выберите адрес ресторана",
//               style: TextStyles.TitleInMenuDelivery
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: listOfAdressesForPickUp.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   title: Text(listOfAdressesForPickUp[index]['address']),
//                   onTap: () async {
//                     // Устанавливаем адрес в провайдере
//                     addressProvider.setAddressForPickUp(listOfAdressesForPickUp[index]['address']);
//                     selectedAddressForPickUp = listOfAdressesForPickUp[index]['address'];
//                     // Вызываем другие методы, если нужно
//                     apicontroller.setRestaurant(listOfAdressesForPickUp[index]['id']);
//                     clearMenu();
//                     Navigator.pop(context);
//                     await apicontroller.addDishes();
//                     // Обновляем состояние, если это необходимо
//                     setState(() {}); // Перерисовка текущего виджета
//                      // Закрыть модальное окно
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//   }
// }