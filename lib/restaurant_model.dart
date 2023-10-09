import 'dart:convert';
import 'package:http/http.dart' as http;

class BookStore {
  final String name;
  final double latitude;
  final double longitude;

  BookStore({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

//fetch json form api
Future<List<BookStore>> fetchKinokuniyaData() async {
  final response = await http.get(
      Uri.parse('https://mocki.io/v1/b8ba2dfb-d890-4229-87e7-8cbb812939a0')); // mock up api that contain lat long of kinokuniya location
      //mock api
  if (response.statusCode == 200) {
    final jsonData = utf8.decode(response.bodyBytes);
    final kinokuniyaBranches = json.decode(jsonData)['kinokuniya_branches_Thailand'] as List<dynamic>;

    final bookStores = kinokuniyaBranches.map((branch) {
      return BookStore(
        name: branch['branch'] as String,
        latitude: (branch['lat'] as num).toDouble(),
        longitude: (branch['lon'] as num).toDouble(),
      );
    }).toList();

    return bookStores;
  } else {
    throw Exception('Failed to load JSON data');
  }
}
