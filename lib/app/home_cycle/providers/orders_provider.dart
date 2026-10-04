import 'dart:developer';
import 'dart:typed_data';

import 'package:drago_usb_printer/drago_usb_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:gosmart_self_checkout/app/home_cycle/models/cart_line.dart';
import 'package:gosmart_self_checkout/app/home_cycle/models/fawry_payment_response.dart';
import 'package:gosmart_self_checkout/app/home_cycle/models/product_by_barcode.dart';
import 'package:gosmart_self_checkout/app/home_cycle/services/orders_apis.dart';
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';

class OrdersProvider with ChangeNotifier {
  String branchId = "1";

  FawryPaymentResponse _fawryPaymentResponse = FawryPaymentResponse();

  FawryPaymentResponse get fawryPaymentResponse => _fawryPaymentResponse;

  set setFawryPaymentResponse(FawryPaymentResponse value) {
    _fawryPaymentResponse = value;

    notifyListeners();
  }

  //* //*
  //* PRINTER TYPE
  bool _isUSBPrinter = false;
  bool get isUSBPrinter => _isUSBPrinter;

  //* USB PRINTER
  DragoUsbPrinter _printerManagerUSB = DragoUsbPrinter();
  int _vendorId = 0;
  int _productId = 0;

  //* WIFI PRINTER
  final PrinterManager _printerManagerWIFI = PrinterManager.instance;
  // BluetoothPrinter _selectedPrinterWIFI = BluetoothPrinter();

  final bool _isConnected = true;

  //* POS CONNECTED
  bool _posConnected = false;
  bool get posConnected => _posConnected;
  set setPosConnected(bool value) {
    _posConnected = value;
    notifyListeners();
  }

  //* //* VARIABLES
  double _cartTotal = 0.0;

  ProductByBarcode _productByBarcode = ProductByBarcode();
  bool _dataLoaded = false;

  // ignore: prefer_final_fields
  List<ProductByBarcode> _cartItems = [];

  //* //* GETTERS
  double get cartTotal => _cartTotal;

  ProductByBarcode get productByBarcode => _productByBarcode;
  bool get dataLoaded => _dataLoaded;

  List<ProductByBarcode> get cartItems => _cartItems;

  //* //*

  DragoUsbPrinter get printerManagerUSB => _printerManagerUSB;
  int get vendorId => _vendorId;
  int get productId => _productId;

  PrinterManager get printerManagerWIFI => _printerManagerWIFI;

  //* //* SETTERS
  set cartTotal(double value) {
    _cartTotal = value;
    notifyListeners();
  }

  set setIsUSBPrinter(bool value) {
    _isUSBPrinter = value;
    notifyListeners();
  }

  set setPrinterManagerUSB(DragoUsbPrinter value) {
    _printerManagerUSB = value;
    notifyListeners();
  }

  set setVendorId(int value) {
    _vendorId = value;
    notifyListeners();
  }

  set setProductId(int value) {
    _productId = value;
    notifyListeners();
  }

  //* //* FUNCTIONS

  Future<void> getProductDetailsByBarcode(String productedBarcode) async {
    _dataLoaded = false;
    //*
    notifyListeners();
    //*
    _productByBarcode =
        (await OrdersApis().getProductDetailsByBarcode(
          productedBarcode,
          branchId,
        ))!;

    //notifyListeners();
    if (_productByBarcode.data!.isNotEmpty) {
      addToCart(_productByBarcode);
    } else {
      print('product not found');

      _productByBarcode.data = [];
    }
    _dataLoaded = true;
    notifyListeners();
  }

  void addToCart(ProductByBarcode product) {
    bool isProductInCart = false;

    for (var item in _cartItems) {
      if (item.data!.first.barcode == product.data!.first.barcode) {
        item.data!.first.selectedQty += 1;
        isProductInCart = true;
        break;
      }
    }
    if (!isProductInCart) {
      _cartItems.add(product);
    }

    calculateCartTotal();
  }

  void decreaseProductQuantity(ProductByBarcode product) {
    for (var item in _cartItems) {
      if (item.data!.first.barcode == product.data!.first.barcode) {
        if (item.data!.first.selectedQty > 1) {
          item.data!.first.selectedQty -= 1;
        } else {
          removeFromCart(product);
        }
        break;
      }
    }

    calculateCartTotal();
  }

  void increaseProductQuantity(ProductByBarcode product) {
    for (var item in _cartItems) {
      if (item.data!.first.barcode == product.data!.first.barcode) {
        item.data!.first.selectedQty += 1;
        break;
      }
    }

    calculateCartTotal();
  }

  void removeFromCart(ProductByBarcode product) {
    _cartItems.removeWhere(
      (item) => item.data!.first.barcode == product.data!.first.barcode,
    );

    calculateCartTotal();
  }

  void clearCartAndResetAll() {
    _cartItems.clear();

    _productByBarcode.data = [];

    _dataLoaded = false;

    calculateCartTotal();
  }

  void calculateCartTotal() {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.data!.first.listPrice! * item.data!.first.selectedQty;
    }
    _cartTotal = total;
    notifyListeners();
  }

  Future<void> submitOrder() async {
    try {
      List<CartLine> lines = [];
      for (var item in _cartItems) {
        if (item.data != null && item.data!.isNotEmpty) {
          final prod = item.data!.first;
          lines.add(
            CartLine(
              productId: prod.id ?? 0,
              productName: prod.nameAr ?? prod.name ?? '',
              selectedQty: prod.selectedQty,
            ),
          );
        }
      }
      if (lines.isNotEmpty) {
        await OrdersApis().placeOrder(lines, branchId);
      }
    } catch (e) {
      log('Error submitting order: $e');
    }
  }

  //* //* //* //* //* //* //*
  //* //* //* //* //* //* //*

  //* //* //* //* //*
  Future printReceipt(
    ScreenshotController screenshotController,
    bool isUSB,
  ) async {
    print('START PRINTING');
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    //*

    var logoFromAssets = await rootBundle.load(
      'assets/images/blubite_logo.jpeg',
    );

    var logo = logoFromAssets.buffer.asUint8List();

    final capturedImage = await screenshotController.capture(
      delay: const Duration(milliseconds: 20),
      pixelRatio: 1.5,
    );

    img.Image? decodedImage = img.decodeImage(capturedImage!);
    img.Image? decodedLogo = img.decodeImage(logo);

    //* TITLE LOGO
    bytes += generator.image(
      decodedLogo!,
      align: PosAlign.center,
      isDoubleDensity: true,
    );

    bytes += generator.image(
      decodedImage!,
      align: PosAlign.center,
      isDoubleDensity: true,
    );

    //* //*

    // bytes += generator.cut();
    //*

    log('isUSB >> $_isUSBPrinter');

    if (_isUSBPrinter) {
      _printEscPosUSB(bytes, generator);
    }
    // else {
    //   _printEscPosWIFI(bytes, generator);
    // }
  }

  List<int>? pendingTask;

  /// print ticket USB
  void _printEscPosUSB(List<int> bytes, Generator generator) async {
    int vendorId = _vendorId;
    int productId = _productId;

    print('V $vendorId');
    print('P $productId');

    bool? isConnected = await _printerManagerUSB.connect(vendorId, productId);
    print('vendodID: $vendorId -- ProductId: $productId -- $isConnected');

    if (isConnected ?? false) {
      //*
      bytes += generator.cut();
      //*

      await _printerManagerUSB.write(Uint8List.fromList(bytes)).then((value) {
        print('WRITE DONE >> $value');
      });

      await _printerManagerUSB.close();
      print('CLOSE DONE');
    }
  }
}
