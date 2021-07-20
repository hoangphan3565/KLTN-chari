import 'package:chari/screens/screens.dart';
import 'package:chari/utility/routing_data.dart';
import 'package:get/get.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    print('queryParameters: ${uriData.queryParameters} path: ${uriData.path}');
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}