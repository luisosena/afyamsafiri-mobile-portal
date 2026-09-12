import 'package:dio/dio.dart';

Future<void> main() async {
  final dio = Dio();
  try {
    final r = await dio.get('https://afyamsafiri.moh.go.tz/mediator/api/');
    print('Status: ${r.statusCode}');
    print(r.data);
  } catch (e) {
    if (e is DioException) {
      print('Status: ${e.response?.statusCode}');
      print('Body: ${e.response?.data}');
    } else {
      print(e);
    }
  }
}