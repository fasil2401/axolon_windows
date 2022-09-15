
class ConnectionModelImpNames {
  static const String connectionName = 'connectionName';
  static const String serverIp = 'serverIp';
  static const String webPort = 'webPort';
  static const String httpPort = 'httpPort';
  static const String erpPort = 'erpPort';
  static const String databaseName = 'databaseName';
  static const String userName = 'userName';
  static const String password = 'password';
  static const String tableName = 'connectionSetting';
}




class ConnectionModel {
  String? connectionName;
  String? serverIp;
  String? webPort;
  String? httpPort;
  String? erpPort;
  String? databaseName;
  String? userName;
  String? password;

  ConnectionModel({
    this.connectionName,
    this.serverIp,
    this.webPort,
    this.httpPort,
    this.erpPort,
    this.databaseName,
    this.userName,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'connectionName': connectionName,
      'serverIp': serverIp,
      'webPort': webPort,
      'httpPort': httpPort,
      'erpPort': erpPort,
      'databaseName': databaseName,
      'userName': userName,
      'password': password,
    };
  }

  ConnectionModel.fromMap(Map<String, dynamic> map) {
    this.connectionName = map['connectionName'];
    this.serverIp = map['serverIp'];
    this.webPort = map['webPort'];
    this.httpPort = map['httpPort'];
    this.erpPort = map['erpPort'];
    this.databaseName = map['databaseName'];
    this.userName = map['userName'];
    this.password = map['password'];
  }
}
