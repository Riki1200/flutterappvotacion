import 'package:device_information/device_information.dart';

Future<Map<String, dynamic>> getInfo() async {
  return {
    'valid': true,
    'plataform': await DeviceInformation.platformVersion,
    'model': await DeviceInformation.deviceModel,
    'devicename': await DeviceInformation.deviceName,
    'nameproduct': await DeviceInformation.productName,
  };
}
