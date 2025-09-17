import 'dart:convert';

import 'package:daily_activity_report/universal_api/api&token.dart';
import 'package:http/http.dart' as http;

import '../model/json_model/cutting_model.dart';

Future<Data> fetchCutting() async {
  final response = await http.get(
    Uri.parse("$apiUrl/Cutting/CUT-2025-00087"),
    headers: {"Authorization": "token $apiKey"},
  );
  if (response.statusCode == 200) {
    print(response.body);
    print(response.statusCode);
    final Map<String, dynamic> json = jsonDecode(response.body);
    return Company.fromJson(json).data!;
  } else {
    throw Exception("Failed to load a Data ${response.statusCode}");
  }
}
