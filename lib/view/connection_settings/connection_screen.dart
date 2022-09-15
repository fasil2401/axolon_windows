import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:axolon_container/controller/app%20controls/connection_setting_controller.dart';
import 'package:axolon_container/controller/app%20controls/local_settings_controller.dart';
import 'package:axolon_container/controller/ui%20controls/password_controller.dart';
import 'package:axolon_container/model/connection_qr_model.dart';
import 'package:axolon_container/model/connection_setting_model.dart';
import 'package:axolon_container/utils/Encryption/encryptor.dart';
import 'package:axolon_container/utils/constants/asset_paths.dart';
import 'package:axolon_container/utils/constants/colors.dart';
import 'package:axolon_container/utils/date_formatter.dart';
import 'package:axolon_container/utils/shared_preferences/shared_preferneces.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ConnectionScreen extends StatefulWidget {
  ConnectionScreen({Key? key, this.connectionModel, this.jsonData = ''})
      : super(key: key);

  ConnectionModel? connectionModel;
  final String? jsonData;

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final passwordController = Get.put(PasswordController());

  final connectionSettingController = Get.put(ConnectionSettingController());

  final localSettingsController = Get.put(LocalSettingsController());

  final _connectiionNameController = TextEditingController();
  final _serverIpController = TextEditingController();
  final _webPortController = TextEditingController();
  final _databaseNameController = TextEditingController();
  final _httpPortController = TextEditingController();
  final _erpPortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('dataaaaaaaaaaa${widget.jsonData}');
    getLocalSettings();
    prefillData();
  }

  var settingsList = [
    ConnectionModel(
        connectionName: 'Select Settings',
        serverIp: '',
        webPort: '',
        httpPort: '',
        erpPort: '',
        databaseName: '')
  ];

  final qrKey = GlobalKey();

  void takeScreenShot() async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // We can increse the size of QR using pixel ratio
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // getting directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${dateFormat.format(DateTime.now()).toString()}axolonERP(${_connectiionNameController.text}).png',
        );
        imgFile.writeAsBytes(pngBytes);
        // GallerySaver.saveImage(imgFile.path).then((success) async {
        //   //In here you can show snackbar or do something in the backend at successfull download
        //   Get.snackbar(
        //     'QR Code',
        //     'QR Code saved to gallery as ${dateFormat.format(DateTime.now()).toString()}axolonERP(${_connectiionNameController.text}).png',
        //     duration: Duration(seconds: 2),
        //   );
        // });
      }
    }
  }

  getLocalSettings() async {
    await localSettingsController.getLocalSettings();
    List<dynamic> settings = localSettingsController.connectionSettings;
    settings.forEach((element) {
      setState(() {
        settingsList.add(element);
      });
    });

    // print(settings);
  }

  selectSettings(ConnectionModel settings) async {
    setState(() {
      _connectiionNameController.text = settings.connectionName!;
      _serverIpController.text = settings.serverIp!;
      _webPortController.text = settings.webPort!;
      _databaseNameController.text = settings.databaseName!;
      _httpPortController.text = settings.httpPort!;
      _erpPortController.text = settings.erpPort!;
    });
    await UserSimplePreferences.setUsername(settings.userName ?? '');
    await UserSimplePreferences.setUserPassword(settings.password ?? '');
    await connectionSettingController
        .getConnectionName(settings.connectionName!);
    await connectionSettingController.getServerIp(settings.serverIp!);
    await connectionSettingController.getWebPort(settings.webPort!);
    await connectionSettingController.getDatabaseName(settings.databaseName!);
    await connectionSettingController.getHttpPort(settings.httpPort!);
    await connectionSettingController.getErpPort(settings.erpPort!);
    print(connectionSettingController.serverIp.value);
  }

  fillDataOnScan() async {
    var jsonData = connectionQrModelFromJson(widget.jsonData!);
    print('object issssssss+++++++++${jsonData.connectionName}');
    var connectionName = EncryptData.decryptAES(jsonData.connectionName);
    print('connectionName issssssss+++++++++${connectionName}');
    var serverIp = EncryptData.decryptAES(jsonData.serverIp);
    var webPort = EncryptData.decryptAES(jsonData.webPort);
    var databaseName = EncryptData.decryptAES(jsonData.databaseName);
    var httpPort = EncryptData.decryptAES(jsonData.httpPort);
    var erpPort = EncryptData.decryptAES(jsonData.erpPort);
    print(connectionName);
    print(serverIp);
    print(webPort);
    print(databaseName);
    print(httpPort);
    print(erpPort);
    setState(() {
      _connectiionNameController.text = connectionName;
      _serverIpController.text = serverIp;
      _webPortController.text = webPort;
      _databaseNameController.text = databaseName;
      _httpPortController.text = httpPort;
      _erpPortController.text = erpPort;
    });
  }

  assignControllers() async {
    await connectionSettingController
        .getConnectionName(_connectiionNameController.text);
    await connectionSettingController.getServerIp(_serverIpController.text);
    await connectionSettingController.getWebPort(_webPortController.text);
    await connectionSettingController
        .getDatabaseName(_databaseNameController.text);
    await connectionSettingController.getHttpPort(_httpPortController.text);
    await connectionSettingController.getErpPort(_erpPortController.text);
  }

  prefillData() async {
    if (widget.jsonData != '') {
      fillDataOnScan();
    } else if (widget.connectionModel != null) {
      setState(() {
        _connectiionNameController.text =
            widget.connectionModel!.connectionName ?? '';
        _serverIpController.text = widget.connectionModel!.serverIp ?? '';
        _webPortController.text = widget.connectionModel!.webPort ?? '';
        _databaseNameController.text =
            widget.connectionModel!.databaseName ?? '';
        _httpPortController.text = widget.connectionModel!.httpPort ?? '';
        _erpPortController.text = widget.connectionModel!.erpPort ?? '';
      });
    } else {
      String connectionName =
          await UserSimplePreferences.getConnectionName() ?? '';
      String serverIp = await UserSimplePreferences.getServerIp() ?? '';
      String webPort = await UserSimplePreferences.getWebPort() ?? '';
      String databaseName = await UserSimplePreferences.getDatabase() ?? '';
      String httpPort = await UserSimplePreferences.getHttpPort() ?? '';
      String erpPort = await UserSimplePreferences.getErpPort() ?? '';
      setState(() {
        _connectiionNameController.text = connectionName;
        _serverIpController.text = serverIp;
        _webPortController.text = webPort;
        _databaseNameController.text = databaseName;
        _httpPortController.text = httpPort;
        _erpPortController.text = erpPort;
      });
    }
  }

  createNew() async {
    setState(() {
      _connectiionNameController.text = '';
      _serverIpController.text = '';
      _webPortController.text = '';
      _databaseNameController.text = '';
      _httpPortController.text = '';
      _erpPortController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    print(settingsList);

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              // AppColors.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            /// Login & Welcome back
            Container(
              height: height * 0.2,
              padding: const EdgeInsets.only(left: 10, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  /// LOGIN TEXT
                  Text('Connection',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                  SizedBox(height: 3.5),

                  /// WELCOME
                  Text('Set your connection settings',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: height * 0.03),

                                Center(
                                  child: SizedBox(
                                    width: width * 0.35,
                                    child: Image.asset(Images.logo,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                // SizedBox(height: height * 0.035),

                                /// Text Fields
                                Stack(
                                  children: [
                                    // Container(
                                    //   margin: const EdgeInsets.symmetric(
                                    //       horizontal: 25, vertical: 30),
                                    //   child: Obx(() => RepaintBoundary(
                                    //         key: qrKey,
                                    //         child: QrImage(
                                    //           backgroundColor: Colors.white,
                                    //           data: connectionSettingController
                                    //               .qrData.value,
                                    //           size: width * 0.5,
                                    //         ),
                                    //       )),
                                    // ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 20),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      // height: height * 0.5,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                blurRadius: 20,
                                                spreadRadius: 10,
                                                offset: const Offset(0, 10)),
                                          ]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          DropdownButtonFormField2(
                                            isDense: true,
                                            dropdownFullScreen: true,
                                            value: settingsList[0],
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 18,
                                            ),
                                            decoration: InputDecoration(
                                              isCollapsed: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                            ),
                                            isExpanded: true,
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: AppColors.primary,
                                            ),
                                            iconSize: 20,
                                            // buttonHeight: 37,
                                            buttonPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            dropdownDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            items: settingsList
                                                .map(
                                                  (item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item.connectionName!,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) async {
                                              var settings =
                                                  value as ConnectionModel;
                                              selectSettings(settings);
                                            },
                                            onSaved: (value) {},
                                          ),
                                          SizedBox(height: height * 0.01),
                                          TextField(
                                            controller:
                                                _connectiionNameController,
                                            style: TextStyle(fontSize: 15),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              border: InputBorder.none,
                                              label: Text(
                                                'Connection Name',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              // isCollapsed: true,
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              suffix: GestureDetector(
                                                onTap: () {
                                                  // Get.to(() => QRViewExample());
                                                },
                                                child: const Icon(
                                                  Icons.qr_code_rounded,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              connectionSettingController
                                                  .getConnectionName(value);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          SizedBox(height: height * 0.01),
                                          TextField(
                                            controller: _serverIpController,
                                            style: TextStyle(fontSize: 15),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              border: InputBorder.none,
                                              label: Text(
                                                'Server Ip',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              isCollapsed: false,
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              connectionSettingController
                                                  .getServerIp(value);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          SizedBox(height: height * 0.01),
                                          TextField(
                                            controller: _webPortController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(fontSize: 15),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              border: InputBorder.none,
                                              label: Text(
                                                'Web Service Port',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              isCollapsed: false,
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            onChanged: (value) async {
                                              await connectionSettingController
                                                  .getWebPort(value);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          SizedBox(height: height * 0.01),
                                          TextField(
                                            controller: _databaseNameController,
                                            style: TextStyle(fontSize: 15),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              border: InputBorder.none,
                                              label: Text(
                                                'Database Name',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              isCollapsed: false,
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            onChanged: (value) async {
                                              await connectionSettingController
                                                  .getDatabaseName(value);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          SizedBox(height: height * 0.01),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            _erpPortController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                          border:
                                                              InputBorder.none,
                                                          label: Text(
                                                            'ERP Port',
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .primary,
                                                            ),
                                                          ),
                                                          isCollapsed: false,
                                                          hintStyle: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        onChanged:
                                                            (value) async {
                                                          await connectionSettingController
                                                              .getErpPort(
                                                                  value);
                                                        },
                                                      ),
                                                      Divider(
                                                          color: Colors.black54,
                                                          height: 1),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.05),
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            _httpPortController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                          border:
                                                              InputBorder.none,
                                                          label: Text(
                                                            'Http Port',
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .primary,
                                                            ),
                                                          ),
                                                          isCollapsed: false,
                                                          hintStyle: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        onChanged:
                                                            (value) async {
                                                          await connectionSettingController
                                                              .getHttpPort(
                                                                  value);
                                                        },
                                                      ),
                                                      Divider(
                                                          color: Colors.black54,
                                                          height: 1),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: height * 0.0,
                                      right: width * 0.065,
                                      child: GestureDetector(
                                        onTap: () {
                                          createNew();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.primary,
                                          radius: 30,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // SizedBox(
                                //   height: height * 0.02,
                                // ),
                                // Container(
                                //   margin: const EdgeInsets.symmetric(horizontal: 25),
                                //   height: height * 0.055,
                                //   width: MediaQuery.of(context).size.width,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //   ),
                                //   child: ElevatedButton(
                                //     onPressed: () {
                                //       connectionSettingController.saveSettings();
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       primary: AppColors.primary,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(10), // <-- Radius
                                //       ),
                                //     ),
                                //     child: Text('Continue',
                                //         style: TextStyle(color: Colors.white)),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: height * 0.01,
                                // ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        height: height * 0.055,
                                        // width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.mutedBlueColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // <-- Radius
                                            ),
                                          ),
                                          child: Text('Cancel',
                                              style: TextStyle(
                                                  color: AppColors.primary)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        height: height * 0.055,
                                        // width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await setData();
                                            // await assignControllers();
                                            connectionSettingController
                                                .saveSettings(settingsList);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // <-- Radius
                                            ),
                                          ),
                                          child: Text('Continue',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  height: height * 0.06,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // await assignControllers();
                                      await setData();
                                      takeScreenShot();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // <-- Radius
                                      ),
                                    ),
                                    child: Text('Encrypt',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.08,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  setData() async {
    await connectionSettingController
        .getConnectionName(_connectiionNameController.text);
    await connectionSettingController.getServerIp(_serverIpController.text);
    await connectionSettingController.getWebPort(_webPortController.text);
    await connectionSettingController
        .getDatabaseName(_databaseNameController.text);
    await connectionSettingController.getErpPort(_erpPortController.text);
    await connectionSettingController.getHttpPort(_httpPortController.text);
  }
}
