import 'package:axolon_container/controller/app%20controls/local_settings_controller.dart';
import 'package:axolon_container/controller/ui%20controls/package_info_controller.dart';
import 'package:axolon_container/model/connection_setting_model.dart';
import 'package:axolon_container/utils/Routes/route_manger.dart';
import 'package:axolon_container/utils/constants/asset_paths.dart';
import 'package:axolon_container/utils/constants/colors.dart';
import 'package:axolon_container/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_container/view/connection_settings/connection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final packageInfoCOntroller = Get.put(PackageInfoController());

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isReloading = false;
  int position = 1;
  WebViewController? _webViewController;
  final localSettingsController = Get.put(LocalSettingsController());
  var settingsList = [];
  final _key = UniqueKey();
  String url = '';
  @override
  void initState() {
    super.initState();
    url =
        'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1';
    generateUrl();
    getLocalSettings();
  }

  getLocalSettings() async {
    await localSettingsController.getLocalSettings();
    List<dynamic> settings = localSettingsController.connectionSettings;
    for (var setting in settings) {
      settingsList.add(setting);
    }
  }

  String serverIp = '';
  String databaseName = '';
  String erpPort = '';
  String username = '';
  String password = '';
  String webPort = '';
  String httpPort = '';

  String webUrl = '';
  generateUrl() async {
    setState(() {
      serverIp = UserSimplePreferences.getServerIp() ?? '';
      databaseName = UserSimplePreferences.getDatabase() ?? '';
      erpPort = UserSimplePreferences.getErpPort() ?? '';
      username = UserSimplePreferences.getUsername() ?? '';
      password = UserSimplePreferences.getUserPassword() ?? '';
      webPort = UserSimplePreferences.getWebPort() ?? '';
      httpPort = UserSimplePreferences.getHttpPort() ?? '';
    });
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    _webViewController!.goBack();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print('webUrlissssss $webUrl');
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: SizedBox(
            width: width * 0.34,
            height: height * 0.075,
            child: Image.asset(
              Images.logo,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                // Get.to(ConnectionScreen());
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              // physics: NeverScrollableScrollPhysics(),
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        Images.user,
                        fit: BoxFit.cover,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mutedColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            // margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                await UserSimplePreferences.setLogin('false');
                                Get.offAllNamed(RouteManager().routes[1].name);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                primary: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Log Out',
                                    style: TextStyle(
                                      // fontSize: width * 0.03,
                                      color: AppColors.mutedBlueColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.logout_rounded,
                                    // size: 15,
                                    color: AppColors.mutedBlueColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(
                  color: AppColors.mutedColor.withOpacity(0.5),
                  thickness: 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: AppColors.mutedBlueColor,
                    leading: Icon(
                      Icons.settings_suggest_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'Connection Settings',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    children: [
                      Column(
                        children: [
                          settingsList.isNotEmpty
                              ? ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: settingsList.length,
                                  itemBuilder: (context, index) {
                                    var connection = UserSimplePreferences
                                            .getConnectionName() ??
                                        '';
                                    return GestureDetector(
                                      onTap: () async {
                                        var connectonName =
                                            settingsList[index].connectionName;
                                        var serverIp =
                                            settingsList[index].serverIp;
                                        var databaseName =
                                            settingsList[index].databaseName;
                                        var erpPort =
                                            settingsList[index].erpPort;
                                        var username =
                                            settingsList[index].userName;
                                        var password =
                                            settingsList[index].password;
                                        var webPort =
                                            settingsList[index].webPort;
                                        var httpPort =
                                            settingsList[index].httpPort;

                                        await UserSimplePreferences
                                            .setConnectionName(connectonName);
                                        await UserSimplePreferences.setServerIp(
                                            serverIp);
                                        await UserSimplePreferences.setDatabase(
                                            databaseName);
                                        await UserSimplePreferences.setErpPort(
                                            erpPort);
                                        await UserSimplePreferences.setUsername(
                                            username);
                                        await UserSimplePreferences
                                            .setUserPassword(password);
                                        await UserSimplePreferences.setWebPort(
                                            webPort);
                                        await UserSimplePreferences.setHttpPort(
                                            httpPort);
                                        Get.back();
                                        await _webViewController!.loadUrl(
                                          'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1',
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Card(
                                          color: settingsList[index]
                                                      .connectionName! ==
                                                  connection
                                              ? AppColors.mutedBlueColor
                                              : Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            dense: true,
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.settings_outlined,
                                                  color: AppColors.primary,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  settingsList[index]
                                                      .connectionName!,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 2,
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      title: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                            height: 10,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            'Please wait...',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ConnectionScreen(
                                  connectionModel: ConnectionModel(
                                      connectionName: 'New Connection',
                                      webPort: '',
                                      databaseName: '',
                                      httpPort: '',
                                      erpPort: '',
                                      serverIp: '')));
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              radius: height * 0.025,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: height * 0.025,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: IndexedStack(
          index: position,
          children: [
            WebView(
              key: _key,
              initialUrl:
                  'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1',
              // initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              zoomEnabled: true,
              debuggingEnabled: true,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              onPageFinished: (finish) {
                setState(
                  () {
                    print(url);
                    isLoading = false;
                    // isReloading = false;
                    position = 0;
                  },
                );
              },
              onPageStarted: (url) => setState(() {
                isLoading = true;
                position = 1;
              }),
            ),
            Container(
              height: height,
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            )
            // isLoading
            //     ? Container(
            //         height: height,
            //         width: width,
            //         child: Center(
            //           child: CircularProgressIndicator(
            //             color: AppColors.primary,
            //           ),
            //         ),
            //       )
            //     : Stack(),
          ],
        ),
      ),
    );
  }
}
