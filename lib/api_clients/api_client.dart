import 'dart:convert'; // Для работы с JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_and_flutter/domain/entity/addressesdata.dart';
import 'package:pizza_and_flutter/domain/entity/post.dart';
import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/menu/menu_main.dart';
import 'package:provider/provider.dart';

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
}


