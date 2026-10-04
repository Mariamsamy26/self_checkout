// import 'dart:typed_data';

// import 'package:drago_usb_printer/drago_usb_printer.dart';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// class USBPrinterSetupWidget extends StatefulWidget {
//   const USBPrinterSetupWidget({super.key});

//   @override
//   State<USBPrinterSetupWidget> createState() => _USBPrinterSetupWidgetState();
// }

// class _USBPrinterSetupWidgetState extends State<USBPrinterSetupWidget> {
//   List<Map<String, dynamic>> devices = [];
//   DragoUsbPrinter dragoUsbPrinter = DragoUsbPrinter();

//   @override
//   initState() {
//     super.initState();
//     _getDevicelist();
//   }

//   _getDevicelist() async {
//     List<Map<String, dynamic>> results = [];
//     results = await DragoUsbPrinter.getUSBDeviceList();

//     print(" length: ${results.length}");
//     setState(() {
//       devices = results;
//     });
//   }

//   List<Widget> _buildList(List<Map<String, dynamic>> devices) {
//     return devices
//         .map((device) => ListTile(
//               leading: Container(
//                   height: 70.h,
//                   width: 70.w,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: goSmartBlue,
//                   ),
//                   child: const Icon(
//                     Icons.usb,
//                     color: white,
//                   )),
//               title: Text(
//                 device['manufacturer'] + " " + device['productName'],
//                 style: TextStyle(fontWeight: FontWeight.w500, color: goSmartBlue, fontSize: 30.sp),
//               ),
//               subtitle: Text(
//                 'Vendor ID: ${device['vendorId']}' "   -   " 'Product ID: ${device['productId']}',
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
//               ),
//               trailing: ElevatedButton.icon(
//                   style: ButtonStyle(
//                     shape: WidgetStatePropertyAll(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                     ),
//                     backgroundColor: const WidgetStatePropertyAll(goSmartBlue),
//                   ),
//                   label: const Text('Select Printer'),
//                   icon: const Icon(Icons.print),
//                   onPressed: () async {
//                     int vendorId = int.parse(device['vendorId']);
//                     int productId = int.parse(device['productId']);
//                     bool? isConnected = await dragoUsbPrinter.connect(vendorId, productId);
//                     if (isConnected ?? false) {
//                       context.read<PosProvider>().setPrinterManagerUSB = dragoUsbPrinter;

//                       context.read<PosProvider>().setVendorId = vendorId;
//                       context.read<PosProvider>().setProductId = productId;

//                       context.read<PosProvider>().setIsUSBPrinter = true;

//                       print('isConntected >> $isConnected');

//                       // Navigation().closeDialog(context);
//                       //* //* //* //* //*
//                       //* //* //* //* //*
//                       //* //* //* //* //*
//                       //* //* //* //* //*
//                       //* //* //* //* //*
//                       //TODO remove comment to print TEST TICKET
//                       List<int> bytes = [];

//                       final profile = await CapabilityProfile.load(name: 'XP-N160I');

//                       final generator = Generator(PaperSize.mm80, profile);
//                       bytes += generator.setGlobalCodeTable('CP1252');

//                       bytes += generator.text('${device['manufacturer'] + " " + device['productName']} Test Ticket',
//                           styles:
//                               const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA, height: PosTextSize.size2));

//                       //* //* //*

//                       bytes += generator.cut();

//                       await dragoUsbPrinter.write(Uint8List.fromList(bytes));
//                       await dragoUsbPrinter.close();

//                       //* //* //*
//                       Navigation().closeDialog(context);
//                     }
//                   }),
//             ))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 100),
//           child: ElevatedButton.icon(
//             style: ButtonStyle(
//               shape: WidgetStatePropertyAll(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//               ),
//               backgroundColor: const WidgetStatePropertyAll(Colors.red),
//             ),
//             onPressed: () {
//               _getDevicelist();
//             },
//             label: const Padding(
//               padding: EdgeInsets.symmetric(vertical: 15),
//               child: Text('Refresh'),
//             ),
//             icon: const Icon(Icons.refresh),
//           ),
//         ),
//         SizedBox(height: 50.h),
//         devices.isEmpty
//             ? Padding(
//                 padding: const EdgeInsets.all(40.0),
//                 child: Text(
//                   'Press Refresh to detect and list connected printers.',
//                   textAlign: TextAlign.center,
//                   style: mediumText.copyWith(fontSize: 30.sp),
//                 ),
//               )
//             : ListView(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.vertical,
//                 children: _buildList(devices),
//               ),
//       ],
//     );
//   }
// }
