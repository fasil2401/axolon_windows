import 'package:axolon_container/utils/constants/asset_paths.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  var status = true.obs;
  var icon = AppIcons.eye_close.obs;

  check() {
    if (status.value == true) {
      status.value = false;
      icon.value = AppIcons.eye_open;
    } else {
      status.value = true;
      icon.value = AppIcons.eye_close;
    }
  }
}
