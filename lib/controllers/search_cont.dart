import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/models/user.dart';

Future<List<UserClass>> searchLink(Map<String, String> body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  User user = userFromJson(prefs.getString('user')!);
  final response = await http.post(Uri.parse(searchUrl),
      body: body, headers: {'Authorization': 'Bearer ${user.token}'});
  print('${user.token}');
  if (response.statusCode == 200) {
    final parsedJson = json.decode(response.body);
    final userList = parsedJson['user'] as List<dynamic>;

    return userList.map((userData) => UserClass.fromJson(userData)).toList();
  } else {
    throw Exception('Failed search');
  }
}
