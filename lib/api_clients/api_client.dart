import 'dart:convert'; // Для работы с JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_and_flutter/carts_and_navigatios/delivery_zone.dart';
import 'package:pizza_and_flutter/domain/entity/addressesdata.dart';
import 'package:pizza_and_flutter/domain/entity/post.dart';
import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/menu/menu_main.dart';
import 'package:provider/provider.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart' as yym;

class ApiClient {
  final int limit; // Максимальное количество позиций для парсинга
  int _restaurant = 0;
  
  void setRestaurant(int restaurant) {
    _restaurant = restaurant;
  } // Получаем id текущего ресторана для определения меню
  
  ApiClient({this.limit = 10000}); // По умолчанию ограничиваем до 5 элементов

  Future<Data> getAdresses() async {
    // Используем http для отправки GET-запроса
    final url = Uri.parse("https://api.apps.inforino.ru/company/74883/settings/v3/addresses");
    final response = await http.get(url);
    // Проверка статуса ответа
    if (response.statusCode == 200) {
      // Преобразуем ответ в JSON
      final json = jsonDecode(response.body);

      // Извлекаем поле "data"
      final data = json['data'] as Map<String, dynamic>;
      // // Получаем список адресов
      final addresses = Data.fromJson(data);
      return addresses;
    } 
    else {
      throw Exception('Failed to load addresses');
    }
  }

  Future<void> addAddresses() async {
    final allAddresses = await getAdresses();
    for (var address in allAddresses.addresses) {
      if(address.deleted == false){ listOfAdressesForPickUp.add({"id" : address.id, "address" : address.address});}
      
      }
      for (var reg in allAddresses.regions) {
List<String> coordinates = reg.vertices!
        .replaceAll(RegExp(r'[\[\]]'), '')
        .split(',');
      for (int i = 0; i < coordinates.length; i += 2) {
    double latitude = double.parse(coordinates[i]);
    double longitude = double.parse(coordinates[i + 1]);
    point.add(yym.Point(latitude: latitude, longitude: longitude));
    }
    points.add(List<yym.Point>.from(point));
    point.clear();
      }
    print(listOfAdressesForPickUp);
  }

  Future<Post> getPosts() async {
    // Используем http для отправки GET-запроса
    final url = Uri.parse("https://api.apps.inforino.ru/company/74883/menu/v2/full");
    final response = await http.get(url);

    // Проверка статуса ответа
    if (response.statusCode == 200) {
      // Преобразуем ответ в JSON
      final json = jsonDecode(response.body);
      // Извлекаем поле "data"
      final data = json['data'] as Map<String, dynamic>;
      // // Получаем список позиций
      // final List<dynamic> positions = data['positions'] as List<dynamic>;
      
      // // Ограничиваем количество позиций
      // final limitedPositions = positions.take(limit).toList();
      // // Обновляем data с ограниченным количеством позиций
      // data['positions'] = limitedPositions;

      // Парсим JSON в объект Post с обновленным списком позиций
      final posts = Post.fromJson(data);
      for (var position in posts.positions) {
        AllPositionsFromServer.add(position);
      }

      for (var entry in posts.prices.entries) {
      AllPricesFromServer[entry.key] = entry.value;
      }
      return posts;
    } 
    else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> addDishes() async {
    // final post = await getPosts();
    bool adressIsExist = false;
    List<int> existingRest = [];
    // final loadingState = Provider.of<CartProvider>(context, listen: false);

    Map<String, dynamic>? getCategoryById(int id) {
      return categorizedMenu.firstWhere(
        (category) => category['category_id'] == id,
      );}
    Map<String, dynamic>? getAdditionalCategoryById(int id) {
      return listOfAdditionalMenu.firstWhere(
        (category) => category['category_id'] == id,
      );}
    
    for (var address in AllPositionsFromServer) {
      if(address.address_id == _restaurant) {adressIsExist = true; break;} 
    }

    if(!adressIsExist){setRestaurant(0);}

    for (var position in AllPositionsFromServer) {
      if(position.address_id == _restaurant && position.deleted == false) {existingRest.add(1); break;} 
    }

    if(existingRest.isEmpty){setRestaurant(0);}

    for (var addingPosition in AllPositionsFromServer) {
          if (addingPosition.deleted == false && addingPosition.address_id == _restaurant)
            if(listOfAdditionalMenuId.contains(addingPosition.menu_cat_id)){
              getAdditionalCategoryById(addingPosition.menu_cat_id)!['items'].add({addingPosition.title : AllPricesFromServer[addingPosition.id]![0]});
              print("${getAdditionalCategoryById(addingPosition.menu_cat_id)!['category_name']} ${addingPosition.title} : ${AllPricesFromServer[addingPosition.id]![0]}");
            }
        }
    for (var position in AllPositionsFromServer) {
      final dish_name = position.title;
      final price = AllPricesFromServer[position.id];
      final weight = position.weight;
      final picture = position.image_url;
      final description = position.descr;
      if (position.deleted == false && position.address_id == _restaurant)
      {
        if(!listOfAdditionalMenuId.contains(position.menu_cat_id) && dish_name == 'Чай')
        categorizedMenu.firstWhere((category) => category['category_name'] == 'Горячие напитки')['items'].add(Dishes(dish_name: dish_name, price: price![0], weight: weight, picture: picture, description: description,));
        else{
        if(!listOfAdditionalMenuId.contains(position.menu_cat_id) && position.menu_cat_id == 10659){
        getCategoryById(position.menu_cat_id)!['items'].add(Dishes(dish_name: dish_name, price: price![0], weight: weight, picture: picture, description: description,));
        }
        if(!listOfAdditionalMenuId.contains(position.menu_cat_id) && position.menu_cat_id != 10659){
        getCategoryById(position.menu_cat_id)!['items'].add(Dishes(dish_name: dish_name, price: price![0], weight: weight, picture: picture, description: description, with_fillings: false,));
        }
        }
      }
      else{print("Элемент не должен отображаться в меню");}
    }
  }

  Future<void> sendOrder(int addressId, double price, List<CartItem> items) async {
  // URL для отправки запроса
  const url = 'http://api.apps.inforino.ru/company/74883/order/v2/create?device=android&udid=709588953abe4f97';

  
  for (var item in items) {
    
  }

  // Тело POST-запроса
  final body = {
    "discount": 5.0,
    "subtotal": price,
    "address_id": addressId,
    "paid_with_bonuses": 0.0,
    "date": "1731492645",
    "paid_with_deposit": 0.0,
    "data_additional_raw": {
      "persons": "",
      "auto": "",
      "arrival_time": "13 ноября в 13:30",
      "comment": "",
      "promo_code": "RU",
      "arrival_time_unixtime": 1731493800
    },
    "data_order_raw": [
      {
        "price": 77.0,
        "name": "Coca cola",
        "position_id": 931271,
        "quantity": 1,
        "position_type_id": 1
      },
      {
        "price": 590.0,
        "article": "Пепперони Премиум\nАнанас",
        "modifiers": {
          "954615": 1,
          "954624": 1
        },
        "name": "Маргарита 42 см",
        "position_id": 931279,
        "quantity": 1,
        "position_type_id": 10
      },
      {
        "price": 499.0,
        "article": "Без добавок\nБез добавок",
        "modifiers": {
          "954629": 1,
          "954608": 1
        },
        "name": "Чесночная 42 см",
        "position_id": 952403,
        "quantity": 1,
        "position_type_id": 10
      }
    ],
    "payform": "online",
    "total": 1107.7,
    "type_id": 1,
    "data_user_raw": {
      "additional": {},
      "birthday": "",
      "email": "",
      "gender": "",
      "name_first": "Konstantin Ustinov",
      "name_last": "",
      "name_middle": "",
      "phone": "+7 926 948-20-68"
    }
  };

  try {
    // Выполнение POST-запроса
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body), // Преобразование тела в JSON
    );

    // Проверка ответа
    if (response.statusCode == 200) {
      print("Order sent successfully: ${response.body}");
    } else {
      print("Failed to send order: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    print("Error sending order: $e");
  }
}
}


