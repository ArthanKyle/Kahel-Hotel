import 'dart:convert';

TopUpModel topUpModelFromJson(String str) =>
    TopUpModel.fromJson(json.decode(str));

String topUpModelToJson(TopUpModel data) => json.encode(data.toJson());

class TopUpModel {
  String linkedAccountId;
  String moneyToSend;
  String totalExpenses;
  String transactionFee;
  String? note;
  String selectedBank;


  TopUpModel({
    required this.linkedAccountId,
    required this.moneyToSend,
    required this.totalExpenses,
    required this.transactionFee,
    required this.selectedBank,
    this.note,
  });

  factory TopUpModel.fromJson(Map<String, dynamic> json) => TopUpModel(
    linkedAccountId: json["linkedAccountId"],
    moneyToSend: json["moneyToSend"],
    totalExpenses: json["totalExpenses"],
    transactionFee: json["transactionFee"],
    note: json["note"] ?? "",
    selectedBank: json["selectedBank"],
  );

  Map<String, dynamic> toJson() => {
    "linkedAccountId": linkedAccountId,
    "moneyToSend": moneyToSend,
    "totalExpenses": totalExpenses,
    "transactionFee": transactionFee,
    "note": note,
    "selectedBank": selectedBank,
  };
}
