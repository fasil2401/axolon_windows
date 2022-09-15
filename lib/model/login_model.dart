import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    Login({
       required this.res,
       required this.msg,
        this.loginToken,
        this.dbName,
        this.userId,
    });

    int res;
    String msg;
    String? loginToken;
    String? dbName;
    String? userId;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        res: json["res"],
        msg: json["msg"],
        loginToken: json["LoginToken"],
        dbName: json["DBName"],
        userId: json["UserID"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "msg": msg,
        "LoginToken": loginToken,
        "DBName": dbName,
        "UserID": userId,
    };
}