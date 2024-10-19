import 'dart:convert'; // Для работы с JSON
import 'dart:io';

import 'package:pizza_and_flutter/domain/entity/post.dart';

class ApiClient {
  final client = HttpClient();

  Future<Post> getPosts() async {
    final url = Uri.parse("https://api.apps.inforino.ru/company/74883/menu/v2/full");
    final request = await client.getUrl(url);
    final response = await request.close();
    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString);
    final data = json['data'] as Map<String, dynamic>;
    final posts = Post.fromJson(data);
    return posts;
  }

  Future<List<Position>> getPositons() async {
    final url = Uri.parse("https://api.apps.inforino.ru/company/74883/menu/v2/full");
    final request = await client.getUrl(url);
    final response = await request.close();
    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString);
    final data = json['data'] as Map<String, dynamic>;
    final posts = Post.fromJson(data);
    return posts.positions;
  }


}