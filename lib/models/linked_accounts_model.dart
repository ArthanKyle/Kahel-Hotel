import 'dart:convert';

LinkAccountsModel linkAccountsModelFromJson(String str) =>
    LinkAccountsModel.fromJson(json.decode(str));

String linkAccountsModelToJson(LinkAccountsModel data) =>
    json.encode(data.toJson());

class LinkAccountsModel {
  String accountName;
  String accountNumber;
  String bank;
  String uid;


  LinkAccountsModel({
    required this.accountName,
    required this.accountNumber,
    required this.bank,
    required this.uid,

  });

  factory LinkAccountsModel.fromJson(Map<String, dynamic> json) =>
      LinkAccountsModel(
        accountName: json["accountName"],
        accountNumber: json["accountNumber"],
        bank: json["bank"],
        uid: json["uid"],

      );

  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "accountNumber": accountNumber,
        "bank": bank,
        "uid": uid,

      };
}
