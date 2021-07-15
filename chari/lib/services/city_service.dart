import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;
class CityService {
  static Future getCity() {
    var url = "$baseUrl$cities";
    return http.get(url);
  }
}