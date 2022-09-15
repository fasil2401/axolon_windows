import 'package:axolon_container/utils/Routes/route_manger.dart';
import 'package:axolon_container/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    enterApp();
  }



  enterApp() async {
    String isConnected = await UserSimplePreferences.getConnection() ?? 'false';
    String isLoggedIn = await UserSimplePreferences.getLogin() ?? 'false';
    await Future.delayed(Duration(seconds: 4), () {
      if (isConnected == 'true') {
        if (isLoggedIn == 'true') {
          Get.offNamed(RouteManager().routes[3].name);
        } else {
          Get.offNamed(RouteManager().routes[1].name);
        }
      } else {
        Get.offNamed(RouteManager().routes[2].name);
      }
    });
  }
}
