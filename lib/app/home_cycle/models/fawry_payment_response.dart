// To parse this JSON data, do
//
//     final fawryPaymentResponse = fawryPaymentResponseFromJson(jsonString);

import 'dart:convert';

FawryPaymentResponse fawryPaymentResponseFromJson(String str) => FawryPaymentResponse.fromJson(json.decode(str));

String fawryPaymentResponseToJson(FawryPaymentResponse data) => json.encode(data.toJson());

class FawryPaymentResponse {
  PaymentResponseVm? paymentResponseVm;

  FawryPaymentResponse({this.paymentResponseVm});

  factory FawryPaymentResponse.fromJson(Map<String, dynamic> json) => FawryPaymentResponse(
    paymentResponseVm: json["PaymentResponseVm"] == null ? null : PaymentResponseVm.fromJson(json["PaymentResponseVm"]),
  );

  Map<String, dynamic> toJson() => {"PaymentResponseVm": paymentResponseVm?.toJson()};
}

class PaymentResponseVm {
  Body? body;
  Header? header;

  PaymentResponseVm({this.body, this.header});

  factory PaymentResponseVm.fromJson(Map<String, dynamic> json) => PaymentResponseVm(
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
  );

  Map<String, dynamic> toJson() => {"body": body?.toJson(), "header": header?.toJson()};
}

class Body {
  String? amount;
  String? balance;
  String? btc;
  String? clientTerminalSequenceId;
  String? currency;
  String? fawryReference;
  String? fees;
  String? paymentOption;
  String? printReceipt;
  ReceiptInfo? receiptInfo;
  String? signature;
  String? tips;
  String? transactionType;

  Body({
    this.amount,
    this.balance,
    this.btc,
    this.clientTerminalSequenceId,
    this.currency,
    this.fawryReference,
    this.fees,
    this.paymentOption,
    this.printReceipt,
    this.receiptInfo,
    this.signature,
    this.tips,
    this.transactionType,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    amount: json["amount"],
    balance: json["balance"],
    btc: json["btc"],
    clientTerminalSequenceId: json["clientTerminalSequenceID"],
    currency: json["currency"],
    fawryReference: json["fawryReference"],
    fees: json["fees"],
    paymentOption: json["paymentOption"],
    printReceipt: json["printReceipt"],
    receiptInfo: json["receiptInfo"] == null ? null : ReceiptInfo.fromJson(json["receiptInfo"]),
    signature: json["signature"],
    tips: json["tips"],
    transactionType: json["transactionType"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "balance": balance,
    "btc": btc,
    "clientTerminalSequenceID": clientTerminalSequenceId,
    "currency": currency,
    "fawryReference": fawryReference,
    "fees": fees,
    "paymentOption": paymentOption,
    "printReceipt": printReceipt,
    "receiptInfo": receiptInfo?.toJson(),
    "signature": signature,
    "tips": tips,
    "transactionType": transactionType,
  };
}

class ReceiptInfo {
  String? acquirerBankId;
  String? authId;
  CardInfo? cardInfo;
  String? convenienceFees;
  String? effDt;
  String? merchantId;
  String? receiptNumber;
  String? rrn;
  String? terminalId;
  String? tips;

  ReceiptInfo({
    this.acquirerBankId,
    this.authId,
    this.cardInfo,
    this.convenienceFees,
    this.effDt,
    this.merchantId,
    this.receiptNumber,
    this.rrn,
    this.terminalId,
    this.tips,
  });

  factory ReceiptInfo.fromJson(Map<String, dynamic> json) => ReceiptInfo(
    acquirerBankId: json["acquirerBankId"],
    authId: json["authId"],
    cardInfo: json["cardInfo"] == null ? null : CardInfo.fromJson(json["cardInfo"]),
    convenienceFees: json["convenienceFees"],
    effDt: json["effDt"],
    merchantId: json["merchantId"],
    receiptNumber: json["receiptNumber"],
    rrn: json["rrn"],
    terminalId: json["terminalId"],
    tips: json["tips"],
  );

  Map<String, dynamic> toJson() => {
    "acquirerBankId": acquirerBankId,
    "authId": authId,
    "cardInfo": cardInfo?.toJson(),
    "convenienceFees": convenienceFees,
    "effDt": effDt,
    "merchantId": merchantId,
    "receiptNumber": receiptNumber,
    "rrn": rrn,
    "terminalId": terminalId,
    "tips": tips,
  };
}

class CardInfo {
  String? appId;
  String? appName;
  String? cardAcctId;
  String? cardNumber;
  String? cardScheme;
  String? issuerBankId;

  CardInfo({this.appId, this.appName, this.cardAcctId, this.cardNumber, this.cardScheme, this.issuerBankId});

  factory CardInfo.fromJson(Map<String, dynamic> json) => CardInfo(
    appId: json["appID"],
    appName: json["appName"],
    cardAcctId: json["cardAcctId"],
    cardNumber: json["cardNumber"],
    cardScheme: json["cardScheme"],
    issuerBankId: json["issuerBankId"],
  );

  Map<String, dynamic> toJson() => {
    "appID": appId,
    "appName": appName,
    "cardAcctId": cardAcctId,
    "cardNumber": cardNumber,
    "cardScheme": cardScheme,
    "issuerBankId": issuerBankId,
  };
}

class Header {
  String? merchantBranchCode;
  String? merchantCode;
  String? messageCode;
  String? password;
  String? posSerialNumber;
  String? requestUuid;
  String? serverTimestamp;
  Status? status;
  String? userName;

  Header({
    this.merchantBranchCode,
    this.merchantCode,
    this.messageCode,
    this.password,
    this.posSerialNumber,
    this.requestUuid,
    this.serverTimestamp,
    this.status,
    this.userName,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    merchantBranchCode: json["merchantBranchCode"],
    merchantCode: json["merchantCode"],
    messageCode: json["messageCode"],
    password: json["password"],
    posSerialNumber: json["posSerialNumber"],
    requestUuid: json["requestUuid"],
    serverTimestamp: json["serverTimestamp"],
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "merchantBranchCode": merchantBranchCode,
    "merchantCode": merchantCode,
    "messageCode": messageCode,
    "password": password,
    "posSerialNumber": posSerialNumber,
    "requestUuid": requestUuid,
    "serverTimestamp": serverTimestamp,
    "status": status?.toJson(),
    "userName": userName,
  };
}

class Status {
  String? hostStatusCode;
  String? hostStatusDesc;
  String? statusCode;
  String? statusDesc;

  Status({this.hostStatusCode, this.hostStatusDesc, this.statusCode, this.statusDesc});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    hostStatusCode: json["hostStatusCode"],
    hostStatusDesc: json["hostStatusDesc"],
    statusCode: json["statusCode"],
    statusDesc: json["statusDesc"],
  );

  Map<String, dynamic> toJson() => {
    "hostStatusCode": hostStatusCode,
    "hostStatusDesc": hostStatusDesc,
    "statusCode": statusCode,
    "statusDesc": statusDesc,
  };
}
