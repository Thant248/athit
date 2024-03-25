import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_frontend/model/SessionState.dart';
import 'package:flutter_frontend/services/groupMessageService/group_message_service.dart';

class workapi {
  Future<SessionData>? fetchSession() async {  
  String? token = await getToken();
  // bool? isLoggedIn = await getLogin();
  if (token == null) {
    throw Exception('Token not available');
  }
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8001/main'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // List<dynamic> jsonList = jsonDecode(response.body);
    // List<groupMessageData> users = jsonList.map((json) => groupMessageData.fromJson(json)).toList();
    Map<String, dynamic> data = jsonDecode(response.body);
    SessionData groups = SessionData.fromJson(data); 
    print(groups);
   
    return groups;
  } else {
    throw Exception('Failed to load userdata');
  }
}
}