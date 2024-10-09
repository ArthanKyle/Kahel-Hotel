import 'dart:convert';

WithdrawAndDepositModel withdrawAndDepositModelFromJson(String str) =>
    WithdrawAndDepositModel.fromJson(json.decode(str));

String withdrawAndDepositModelToJson(WithdrawAndDepositModel data) =>
    json.encode(data.toJson());

class WithdrawAndDepositModel {
  String name;
  String accountNumber;
  String bank;
  String uid;
  String totalAmount;
  String amount;
  String transactionFee;
  String typeReceipt;

  WithdrawAndDepositModel({
    required this.name,
    required this.accountNumber,
    required this.bank,
    required this.uid,
    required this.totalAmount,
    required this.amount,
    required this.transactionFee,
    required this.typeReceipt,
  });

  factory WithdrawAndDepositModel.fromJson(Map<String, dynamic> json) =>
      WithdrawAndDepositModel(
        name: json["name"],
        accountNumber: json["accountNumber"],
        bank: json["bank"],
        uid: json["uid"],
        totalAmount: json["totalAmount"],
        amount: json["amount"],
        transactionFee: json["transactionFee"],
        typeReceipt: json["typeReceipt"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "accountNumber": accountNumber,
        "bank": bank,
        "uid": uid,
        "totalAmount": totalAmount,
        "amount": amount,
        "transactionFee": transactionFee,
        "typeReceipt": typeReceipt,
      };
}
