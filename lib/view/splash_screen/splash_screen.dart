import 'package:axolon_container/controller/app%20controls/splash_screen_controller.dart';
import 'package:axolon_container/utils/constants/asset_paths.dart';
import 'package:axolon_container/utils/constants/colors.dart';
import 'package:axolon_container/controller/ui%20controls/package_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final packageInfoCOntroller = Get.put(PackageInfoController());
  final splashScreenController = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: width * 0.9,
              child: Image.asset(
                Images.logo_gif,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Obx(
                () => Text(
                  'version :${packageInfoCOntroller.version.value}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
