import 'dart:async';
import 'dart:convert';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class RecommendSupportedPeople {
  static Future sendInformation(String referrerName,String referrerPhone,String description,
                                String fullName,String address,String phoneNumber,String bankName,String bankAccount,String token) {
    var url = "$baseUrl$supported_people_recommends";
    final body = jsonEncode(<String, dynamic>{

    });
    return http.post(url,headers:getHeaderJWT(token),body: body);
  }
}