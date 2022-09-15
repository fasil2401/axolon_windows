
import 'dart:convert';

ConnectionQrModel connectionQrModelFromJson(String str) => ConnectionQrModel.fromJson(json.decode(str));

String connectionQrModelToJson(ConnectionQrModel data) => json.encode(data.toJson());

class ConnectionQrModel {
    ConnectionQrModel({
        this.connectionName,
        this.serverIp,
        this.webPort,
        this.databaseName,
        this.httpPort,
        this.erpPort,
    });

    String? connectionName;
    String? serverIp;
    String? webPort;
    String? databaseName;
    String? httpPort;
    String? erpPort;

    factory ConnectionQrModel.fromJson(Map<String, dynamic> json) => ConnectionQrModel(
        connectionName: json["connectionName"],
        serverIp: json["serverIp"],
        webPort: json["webPort"],
        databaseName: json["databaseName"],
        httpPort: json["httpPort"],
        erpPort: json["erpPort"],
    );

    Map<String, dynamic> toJson() => {
        "connectionName": connectionName,
        "serverIp": serverIp,
        "webPort": webPort,
        "databaseName": databaseName,
        "httpPort": httpPort,
        "erpPort": erpPort,
    };
}
