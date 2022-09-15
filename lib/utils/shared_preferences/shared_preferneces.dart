import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;
  static const _keyConnectionName = 'connectionName';
  static const _keyServerIp = 'server_ip';
  static const _keyWebPort = 'webPort';
  static const _keyHttpPort = 'httpPort';
  static const _keyErpPort = 'erpPort';
  static const _keyServerDatabase = 'database';
  static const _keyUserName = 'username';
  static const _keyUserPassword = 'password';
  static const _keyIslogedIn = 'islogedin';
  static const _keyConnection = 'isConnected';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setConnectionName(String connectionName) async =>
      await _preferences!.setString(_keyConnectionName, connectionName);

  static String? getConnectionName() => _preferences!.getString(_keyConnectionName);

  static Future setUsername(String userName) async =>
      await _preferences!.setString(_keyUserName, userName);

  static String? getUsername() => _preferences!.getString(_keyUserName);

  static Future setUserPassword(String password) async =>
      await _preferences!.setString(_keyUserPassword, password);

  static String? getUserPassword() => _preferences!.getString(_keyUserPassword);

  static Future setServerIp(String serverIp) async =>
      await _preferences!.setString(_keyServerIp, serverIp);

  static String? getServerIp() => _preferences!.getString(_keyServerIp);

  static Future setWebPort(String port) async =>
      await _preferences!.setString(_keyWebPort, port);

  static String? getWebPort() => _preferences!.getString(_keyWebPort);

  static Future setHttpPort(String port) async =>
      await _preferences!.setString(_keyHttpPort, port);

  static String? getHttpPort() => _preferences!.getString(_keyHttpPort);

  static Future setErpPort(String port) async =>
      await _preferences!.setString(_keyErpPort, port);

  static String? getErpPort() => _preferences!.getString(_keyErpPort);

  static Future setDatabase(String database) async =>
      await _preferences!.setString(_keyServerDatabase, database);

  static String? getDatabase() => _preferences!.getString(_keyServerDatabase);

  static Future setLogin(String isLogin) async =>
      await _preferences!.setString(_keyIslogedIn, isLogin);

  static String? getLogin() => _preferences!.getString(_keyIslogedIn);

  static Future setConnection(String isConnected) async =>
      await _preferences!.setString(_keyConnection, isConnected);

  static String? getConnection() => _preferences!.getString(_keyConnection);
}
