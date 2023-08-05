import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/models/user.dart';

Future<bool> addUserCont(Map<String, String> body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  User user = userFromJson(prefs.getString('user')!);
  final response = await http.post(Uri.parse(addUserUrl),
      body: body, headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    // final parsedJson = json.decode(response.body);
    // return parsedJson['followee']['user'];

    return true;
  } else if (response.statusCode == 500) {
    return false;
  } else {
    throw Exception('Failed add user');
  }
}
