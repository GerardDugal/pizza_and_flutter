import 'dart:convert'; // Для работы с JSON
import 'package:http/http.dart' as http;
import 'package:pizza_and_flutter/domain/entity/post.dart';

class ApiClient {
  final int limit; // Максимальное количество позиций для парсинга

  ApiClient({this.limit = 300}); // По умолчанию ограничиваем до 5 элементов

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
      // Получаем список позиций
      final List<dynamic> positions = data['positions'] as List<dynamic>;
      
      // Ограничиваем количество позиций
      final limitedPositions = positions.take(limit).toList();
      // Обновляем data с ограниченным количеством позиций
      data['positions'] = limitedPositions;

      // Парсим JSON в объект Post с обновленным списком позиций
      final posts = Post.fromJson(data);
      
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
