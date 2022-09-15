import 'package:axolon_container/controller/app%20controls/login_controller.dart';
import 'package:axolon_container/model/login_model.dart';
import 'package:axolon_container/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RemoteServicesLogin {
  final loginController = Get.put(LoginController());
  Future<Login?> getLogin(String url, String data) async {

    final response = await http.post(
      Uri.parse(url),
    );

    if (response.statusCode == 302) {
      await UserSimplePreferences.setLogin('true');
      loginController.getWebView();
    } else {
      final String responseString = response.body;
      print(responseString);
      return loginFromJson(responseString);
    }
  }
}
