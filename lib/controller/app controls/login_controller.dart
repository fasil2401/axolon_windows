import 'dart:convert';
import 'package:axolon_container/controller/app%20controls/local_settings_controller.dart';
import 'package:axolon_container/services/login_services.dart';
import 'package:axolon_container/utils/Routes/route_manger.dart';
import 'package:axolon_container/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final localSettingsController = Get.put(LocalSettingsController());
  @override
  void onInit() {
    super.onInit();
  }

  var isLoading = false.obs;
  var userName = ''.obs;
  var password = ''.obs;
  var res = 0.obs;
  var message = ''.obs;
  var token = ''.obs;
  var webUrl = ''.obs;
  String url = '';
  String data = '';

  getUserName(String userName) {
    this.userName.value = userName;
  }

  getPassword(String password) {
    this.password.value = password;
  }

  updateConnectionSetting() async {
    String connectionName =
        await UserSimplePreferences.getConnectionName() ?? '';
    // await localSettingsController.updateLocalSettings(
    //     connectionName: connectionName,
    //     userName: userName.value,
    //     password: password.value);
  }

  saveCredentials() async {
    await updateConnectionSetting();
    await UserSimplePreferences.setUsername(userName.value);
    await UserSimplePreferences.setUserPassword(password.value);
    // getLogin();
    genearateApi();
  }

  genearateApi() async {
    final String serverIp = await UserSimplePreferences.getServerIp() ?? '';
    final String databaseName = await UserSimplePreferences.getDatabase() ?? '';
    final String erpPort = await UserSimplePreferences.getErpPort() ?? '';
    final String httpPort = await UserSimplePreferences.getHttpPort() ?? '';
    final String username = await UserSimplePreferences.getUsername() ?? '';
    final String password = await UserSimplePreferences.getUserPassword() ?? '';
    final String webPort = await UserSimplePreferences.getWebPort() ?? '';
    url = 'http://${serverIp}/V1/Api/Gettoken';
    data = jsonEncode({
      "instance": serverIp,
      "userId": username,
      "Password": password,
      "passwordhash": "",
      "dbName": databaseName,
      "port": webPort,
      "servername": ""
    });
    webUrl.value =
        'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1';

    getLogin();
  }

  getLogin() async {
    try {
      print(webUrl.value);
      isLoading.value = true;
      var feedback = await RemoteServicesLogin().getLogin(webUrl.value, data);
      if (feedback != null) {
        res.value = feedback.res;
        message.value = feedback.msg;
        // token.value = feedback.loginToken!;
        Get.snackbar('Error', message.value);
      } else {
        // message.value = 'failure';
      }
    } finally {
      if (res.value == 1) {
        isLoading.value = false;
        // await UserSimplePreferences.setLogin('true');
        // getWebView();
      } else {
        // Get.back();
        isLoading.value = false;
      }
    }
  }

  getWebView() async {
    print(webUrl.value);
    Get.offAllNamed(RouteManager().routes[3].name);
  }
}
