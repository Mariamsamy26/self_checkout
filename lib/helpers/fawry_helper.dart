import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:gosmart_self_checkout/app/home_cycle/models/fawry_payment_response.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/helpers/navigation_helper.dart';
import 'package:gosmart_self_checkout/services/dio_client.dart';
import 'package:gosmart_self_checkout/widget/ok_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart' as xml;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:xml2json/xml2json.dart';

class FawryHelper {
  static String userName = '507080';
  static String passwordDecrypted = '135792';
  static String posSerialNumber = 'N500Z063569';
  static String messageCode = 'purchase';
  static String paymentOption = 'card';
  static String secretKey = '10cd72d0-8f0f-4306-81e0-39e9b8a7943d';

  //////////////////////////////////////*///////////////////////////////////////

  BigInt getData(xml.XmlDocument xmlDocument, String element) {
    var dataB64 = xmlDocument.findAllElements(element).single.innerText;
    var dataBytes = Uint8List.fromList(base64.decode(dataB64));
    return BigInt.parse(hex.encode(dataBytes), radix: 16);
  }

  String encryptPassword(String password) {
    //*
    var publicKeyXML =
        '''<RSAKeyValue><Modulus>u9Xlg7fTrxJ66aa1xrpkjNYr+7m3/6+zd5LkoShzka1mALMujU7m7a1FLxUPM1scaIwWkRgykuxrajhdG5X7ehwMX2BKxsCyKCErx7jZl16U5xvtpXVJYCoA50PgNS8Y4A7WrbZwhaBftK9vPvoQ2kXziF1ZTWI+G9YQU/glaqM=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>''';
    var xmlDocument = xml.XmlDocument.parse(publicKeyXML);
    var modulus = getData(xmlDocument, 'Modulus');
    var exponent = getData(xmlDocument, 'Exponent');
    var publicKey = RSAPublicKey(modulus, exponent);
    //*
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    final encryptedPassword = encrypter.encrypt(password);

    log('ENCRYPTED PASSWORD >> ${encryptedPassword.base64}');
    log('//////////////////////////////////////////////////////');

    return encryptedPassword.base64;
  }

  dynamic hashSha256thenBase64(String data) {
    //  log('initData >> $data');
    var bytes = utf8.encode(data);

    var hashedData = sha256.convert(bytes);
    // log('SHA256 >>  $hashedData'); //* ALL GOOD

    var encodedData = base64.encode(utf8.encode(hashedData.toString()));

    log('base64Encode >>  $encodedData');

    return encodedData;
  }

  Map<String, dynamic> setUpDataForFawryAPIPurchase(double amount) {
    var uuid = const Uuid();

    String clientTimeStamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String requestUuid = uuid.v4();
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    String encryptedPassword = encryptPassword(passwordDecrypted);

    String signature =
        '$userName$encryptedPassword$posSerialNumber$messageCode$clientTimeStamp$requestUuid$amount$orderId$paymentOption$secretKey';

    log(signature);

    Map<String, dynamic> apiData = {
      "amount": amount,
      "clientTimeStamp": clientTimeStamp,
      "requestUuid": requestUuid,
      "orderId": orderId,
      "encryptedPassword": encryptedPassword,
      "signature": hashSha256thenBase64(signature),
    };

    return apiData;
  }

  Map<String, dynamic> setUpDataForFawryAPIVoidTransaction(String purchaseOrderId, String transactionFCRN, String orderId) {
    String voidMessageCode = 'void';

    var uuid = const Uuid();

    String clientTimeStamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String requestUuid = uuid.v4();

    String encryptedPassword = encryptPassword(passwordDecrypted);

    String signature =
        '$userName$encryptedPassword$posSerialNumber$voidMessageCode$clientTimeStamp$requestUuid$transactionFCRN$paymentOption$secretKey';

    log(signature);

    Map<String, dynamic> apiData = {
      "clientTimeStamp": clientTimeStamp,
      "requestUuid": requestUuid,
      //    "purchaseOrderId": purchaseOrderId,
      //"orderId": orderId,
      "encryptedPassword": encryptedPassword,
      "transactionFCRN": transactionFCRN,
      "messageCode": voidMessageCode,
      "signature": hashSha256thenBase64(signature),
    };

    print(apiData);

    return apiData;
  }

  Map<String, dynamic> setUpDataForFawryAPIRefund(String purchaseOrderId, String transactionFCRN, String orderId, String amount) {
    String refundMessageCode = 'refund';

    var uuid = const Uuid();

    String clientTimeStamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String requestUuid = uuid.v4();

    String encryptedPassword = encryptPassword(passwordDecrypted);

    String signature =
        '$userName$encryptedPassword$posSerialNumber$refundMessageCode$clientTimeStamp$requestUuid$amount$transactionFCRN$paymentOption$secretKey';

    log(signature);

    Map<String, dynamic> apiData = {
      "clientTimeStamp": clientTimeStamp,
      "requestUuid": requestUuid,
      "purchaseOrderId": purchaseOrderId,
      "orderId": orderId,
      "encryptedPassword": encryptedPassword,
      "transactionFCRN": transactionFCRN,
      "messageCode": refundMessageCode,
      "amount": amount,
      "signature": hashSha256thenBase64(signature),
    };

    print(apiData);

    return apiData;
  }

  Map<String, dynamic> setUpDataForFawryAPIFCRNInquiry(String fcrn) {
    var uuid = const Uuid();

    String clientTimeStamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String requestUuid = uuid.v4();
    String encryptedPassword = encryptPassword(passwordDecrypted);
    String inquiryMessageCode = 'inquiry';

    String signature =
        '$userName$encryptedPassword$posSerialNumber$inquiryMessageCode$clientTimeStamp$requestUuid$fcrn$secretKey';

    log(signature);

    Map<String, dynamic> apiData = {
      "clientTimeStamp": clientTimeStamp,
      "requestUuid": requestUuid,
      "encryptedPassword": encryptedPassword,
      "signature": hashSha256thenBase64(signature),
      "FCRN": fcrn,
    };

    print(apiData.toString());

    return apiData;
  }

  //* //* //* //* //* //* //* //* //* //* //* //* //* //*
  //* //* //* //* //* //* //* //* //* //* //* //* //* //*
  //* //* //* //* //* //* //* //* //* //* //* //* //* //*
  //* //* //* //* //* //* //* //* //* //* //* //* //* //*
  //* //* //* //* //* //* //* //* //* //* //* //* //* //*
  //* //* //* //* //* //* //* //* //* //* //* //* //* //*

  Future<String?> fawryPurchase(Map<String, dynamic> apiData, BuildContext context) async {
    String url = 'https://mw.fawrystaging.com:2581/WebSocket/PaymentRequest';

    log(''' {
        "header": {
          "clientTimestamp": "${apiData['clientTimeStamp']}",
          "messageCode": "$messageCode",
          "password": "${apiData['encryptedPassword']}",
          "requestUuid": "${apiData['requestUuid']}",
          "username": "$userName",
          "posSerialNumber": "$posSerialNumber",
          "merchantBranchCode": "1446106785",
          "merchantCode": "1231982560"
        },
        "body": {
          "autoConfirm": true,
          "amount": "${apiData['amount']}",
          "currency": "EGP",
          "displayInvoice": true,
          "printReceipt": false,
          "orderId": "${apiData['orderId']}",
          "paymentOption": "card",
          "signature": "${apiData['signature']}"
        }''');

    try {
      final response = await Client.client.post(
        url,
        data: {
          "header": {
            "clientTimestamp": apiData['clientTimeStamp'],
            "messageCode": messageCode,
            "password": apiData['encryptedPassword'],
            "requestUuid": apiData['requestUuid'],
            "username": userName,
            "posSerialNumber": posSerialNumber,
            "merchantBranchCode": "1446106785",
            "merchantCode": "1231982560",
          },
          "body": {
            "autoConfirm": true,
            "amount": apiData['amount'],
            "currency": "EGP",
            "displayInvoice": true,
            "printReceipt": false,
            "orderId": apiData['orderId'],
            "paymentOption": "card",
            "signature": apiData['signature'],
          },
        },
      );

      if (response.statusCode == 200) {
        // log(response.data.toString());

        final xmlResponse = response.data.toString();
        final xml2json = Xml2Json();
        xml2json.parse(xmlResponse);

        final jsonString = xml2json.toParker();

        log(jsonString);

        FawryPaymentResponse fawryPaymentResponse = FawryPaymentResponse.fromJson(json.decode(jsonString));

        context.read<OrdersProvider>().setFawryPaymentResponse = fawryPaymentResponse;

        //*

        return fawryPaymentResponse.paymentResponseVm!.header!.status!.statusDesc;
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log(e.response!.data.toString());

        print(e.response!.headers);
        print(e.response!.requestOptions);
        //*
        //*
        if (e.response!.data.toString().toLowerCase().contains('not connected')) {
          //*
          showDialog(
            context: context,
            builder:
                (context) => OkDialog(
                  dialogText: 'Please Restart POS Socket Connection and Try Again',
                  onPressed: () {
                    Navigation().closeDialog(context);
                    Navigation().closeDialog(context);
                  },
                ),
          );
        } else {
          //*
          showDialog(
            context: context,
            builder:
                (context) => OkDialog(
                  dialogText: e.response!.data.toString(),
                  onPressed: () {
                    Navigation().closeDialog(context);
                  },
                ),
          );
          //*
        }

        //*
        //*
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      throw 'initPurchase error >> $e';
    }
  }

  Future<Map<String, dynamic>?> fawryVoidTransaction(Map<String, dynamic> apiData, BuildContext context) async {
    String url = 'https://mw.fawrystaging.com:2581/WebSocket/VoidRequest';

    log(''' {
        "header": {
          "clientTimestamp": "${apiData['clientTimeStamp']}",
          "messageCode": "${apiData['messageCode']}",
          "password": "${apiData['encryptedPassword']}",
          "requestUuid": "${apiData['requestUuid']}",
          "username": "$userName",
          "posSerialNumber": "$posSerialNumber",
          "merchantBranchCode": "1446106785",
          "merchantCode": "1231982560"
        },
        "body": {
          "autoConfirm": true,
          "displayInvoice": true,
          "paymentOption": "card",
          "printReceipt": false,
          "signature": "${apiData['signature']}"
          "transactionFCRN": "${apiData['transactionFCRN']}",
          "purchaseOrderId": "${apiData['purchaseOrderId']}",
          "orderId": "${apiData['orderId']}",
        }''');

    try {
      final response = await Client.client.post(
        url,
        data: {
          "header": {
            "clientTimestamp": apiData['clientTimeStamp'],
            "messageCode": messageCode,
            "password": apiData['encryptedPassword'],
            "requestUuid": apiData['requestUuid'],
            "username": userName,
            "posSerialNumber": posSerialNumber,
            "merchantBranchCode": "1446106785",
            "merchantCode": "1231982560",
          },
          "body": {
            "autoConfirm": true,
            "displayInvoice": true,
            "paymentOption": "card",
            "printReceipt": false,
            "signature": apiData['signature'],
            "transactionFCRN": apiData['transactionFCRN'],
            // "purchaseOrderId": apiData['purchaseOrderId'],
            //"orderId": apiData['orderId'],
          },
        },
      );

      if (response.statusCode == 200) {
        log(response.data.toString());

        final xmlResponse = response.data.toString();
        final xml2json = Xml2Json();
        xml2json.parse(xmlResponse);

        final jsonString = xml2json.toParker();

        log(jsonString);

        var responseMap = json.decode(jsonString);
        print('STATUS CODE: ${responseMap['VoidResponseVm']['header']['status']['statusCode']}');
        print('STATUS DESC: ${responseMap['VoidResponseVm']['header']['status']['statusDesc']}');

        var statusCode = responseMap['VoidResponseVm']['header']['status']['statusCode'];
        var statusDescription = responseMap['VoidResponseVm']['header']['status']['statusDesc'];

        Map<String, dynamic> statusDescMap = {'statusCode': statusCode, 'statusDescription': statusDescription};

        return statusDescMap;
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
      //*
      Navigation().closeDialog(context);
      //*
      throw 'fawryVoidTransaction error >> $e';
    }
  }

  Future<Map<String, dynamic>?> fawryRefundPayment(Map<String, dynamic> apiData, BuildContext context) async {
    String url = 'https://mw.fawrystaging.com:2581/WebSocket/RefundRequest';

    log(''' {
        "header": {
          "clientTimestamp": ${apiData['clientTimeStamp']},
          "messageCode": ${apiData['messageCode']},
          "password": ${apiData['encryptedPassword']},
          "requestUuid": ${apiData['requestUuid']},
          "username": $userName,
          "posSerialNumber": $posSerialNumber,
          "merchantBranchCode": "1446106785",
          "merchantCode": "1231982560"
        },
        "body": {
          "amount": ${apiData['amount']},
          "transactionFCRN": ${apiData['transactionFCRN']},
          "printReceipt": false,
          "displayInvoice": true,
          "paymentOption": "card",
          "signature": ${apiData['signature']}
          "autoConfirm": true,
        }''');

    try {
      final response = await Client.client.post(
        url,
        data: {
          "header": {
            "clientTimestamp": apiData['clientTimeStamp'],
            "messageCode": messageCode,
            "password": apiData['encryptedPassword'],
            "requestUuid": apiData['requestUuid'],
            "username": userName,
            "posSerialNumber": posSerialNumber,
            "merchantBranchCode": "1446106785",
            "merchantCode": "1231982560",
          },
          "body": {
            "amount": apiData['amount'],
            "transactionFCRN": apiData['transactionFCRN'],
            "printReceipt": false,
            "autoConfirm": true,
            "displayInvoice": true,
            "paymentOption": "card",
            "signature": apiData['signature'],
          },
        },
      );

      if (response.statusCode == 200) {
        log(response.data.toString());

        final xmlResponse = response.data.toString();
        final xml2json = Xml2Json();
        xml2json.parse(xmlResponse);

        final jsonString = xml2json.toParker();

        log(jsonString);

        var responseMap = json.decode(jsonString);
        print('STATUS CODE: ${responseMap['RefundResponseVm']['header']['status']['statusCode']}');
        print('STATUS DESC: ${responseMap['RefundResponseVm']['header']['status']['statusDesc']}');

        var statusCode = responseMap['RefundResponseVm']['header']['status']['statusCode'];
        var statusDescription = responseMap['RefundResponseVm']['header']['status']['statusDesc'];

        Map<String, dynamic> statusDescMap = {'statusCode': statusCode, 'statusDescription': statusDescription};

        return statusDescMap;
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
        //*
        if (e.response!.data.toString().toLowerCase().contains('not connected')) {
          //*
          showDialog(
            context: context,
            builder:
                (context) => OkDialog(
                  dialogText: 'Please Restart POS Socket Connection and Try Again',
                  onPressed: () {
                    Navigation().closeDialog(context);
                    Navigation().closeDialog(context);
                  },
                ),
          );
        } else {
          //*
          showDialog(
            context: context,
            builder:
                (context) => OkDialog(
                  dialogText: e.response!.data.toString(),
                  onPressed: () {
                    Navigation().closeDialog(context);
                  },
                ),
          );
          //*
        }
        //*
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
      throw 'fawryRefundPayment error >> $e';
    }
  }

  Future<Map<String, dynamic>?> fawryInquiryTest(Map<String, dynamic> apiData, BuildContext context) async {
    String url = 'https://mw.fawrystaging.com:2581/WebSocket/PaymentInquirybyFCRN';

    try {
      final response = await Client.client.post(
        url,
        data: {
          "header": {
            "clientTimestamp": apiData['clientTimeStamp'],
            "messageCode": messageCode,
            "password": apiData['encryptedPassword'],
            "requestUuid": apiData['requestUuid'],
            "username": userName,
            "posSerialNumber": posSerialNumber,
            "merchantBranchCode": "1446106785",
            "merchantCode": "1231982560",
          },
          "body": {
            "displayInvoice": false,
            "idType": "FCRN",
            "printReceipt": false,
            "transactionId": apiData['FCRN'],
            "signature": apiData['signature'],
            "fromDate": "",
            "toDate": "",
            "autoConfirm": true,
          },
        },
      );

      if (response.statusCode == 200) {
        log(response.data.toString());

        final xmlResponse = response.data.toString();
        final xml2json = Xml2Json();
        xml2json.parse(xmlResponse);

        final jsonString = xml2json.toParker();

        log(jsonString);

        var responseMap = json.decode(jsonString);
        print('STATUS CODE: ${responseMap['PaymentInquiryResponseVm']['header']['status']['statusCode']}');
        print('STATUS DESC: ${responseMap['PaymentInquiryResponseVm']['header']['status']['statusDesc']}');

        var statusCode = responseMap['PaymentInquiryResponseVm']['header']['status']['statusCode'];
        var statusDescription = responseMap['PaymentInquiryResponseVm']['header']['status']['statusDesc'];

        Map<String, dynamic> statusDescMap = {
          'statusCode': statusCode,
          'statusDescription':
              //  'POS Setup is Successful'
              'تم تهيئة الـ POS بنجاح',
        };

        context.read<OrdersProvider>().setPosConnected = true;

        return statusDescMap;
      } else {
        return null;
      }
    } on DioException catch (e) {
      //*
      Navigation().closeDialog(context);
      //*
      if (e.response != null) {
        print('data: ${e.response!.data}');

        String responseData = e.response!.data.toString().substring(e.response!.data.toString().lastIndexOf('statusDesc'));
        var edited = responseData.replaceAll('}', '');

        log(edited);

        if (edited.toLowerCase().contains('not connected')) {
          //*
          showDialog(
            context: context,
            builder:
                (context) => OkDialog(
                  dialogText: 'Please Restart POS Socket Connection and Try Again',
                  onPressed: () {
                    Navigation().closeDialog(context);
                  },
                ),
          );
          //*
        } else {
          //*
          showDialog(
            context: context,
            builder:
                (context) => OkDialog(
                  dialogText: edited,
                  onPressed: () {
                    Navigation().closeDialog(context);
                  },
                ),
          );
          //*
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      //*
      context.read<OrdersProvider>().setPosConnected = false;
      //*

      throw 'fawryInquiryTest error >> $e';
    }
  }
}
