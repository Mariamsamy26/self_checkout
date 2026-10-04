import 'package:drago_usb_printer/drago_usb_printer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/helpers/fawry_helper.dart';
import 'package:gosmart_self_checkout/helpers/navigation_helper.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/buttons.dart';
import 'package:gosmart_self_checkout/widget/ok_dialog.dart';
import 'package:provider/provider.dart';

class USBPrinterSetupWidget extends StatefulWidget {
  const USBPrinterSetupWidget({super.key});

  @override
  State<USBPrinterSetupWidget> createState() => _USBPrinterSetupWidgetState();
}

class _USBPrinterSetupWidgetState extends State<USBPrinterSetupWidget> {
  List<Map<String, dynamic>> devices = [];
  DragoUsbPrinter dragoUsbPrinter = DragoUsbPrinter();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDevicelist();
  }

  Future<void> _getDevicelist() async {
    setState(() => _isLoading = true);
    try {
      List<Map<String, dynamic>> results =
          await DragoUsbPrinter.getUSBDeviceList();
      setState(() {
        devices = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrdersProvider>();
    final isPrinterConnected =
        orderProvider.isUSBPrinter &&
        orderProvider.vendorId != 0 &&
        orderProvider.productId != 0;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: goSmartBlueLight,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.settings_suggest_rounded,
                      color: goSmartBlue,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Text(
                    'hardware_settings'.tr(),
                    style: boldText.copyWith(
                      fontSize: 24.sp,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigation().closeDialog(context),
                icon: Icon(Icons.close_rounded, size: 28.sp, color: textMuted),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Status Banner
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: isPrinterConnected ? emeraldGreenLight : amberWarningLight,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isPrinterConnected
                    ? emeraldGreen.withValues(alpha: 0.3)
                    : amberWarning.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPrinterConnected
                      ? Icons.check_circle_rounded
                      : Icons.warning_amber_rounded,
                  color: isPrinterConnected ? emeraldGreen : amberWarning,
                  size: 28.sp,
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPrinterConnected
                            ? 'printer_connected'.tr()
                            : 'printer_disconnected'.tr(),
                        style: boldText.copyWith(
                          fontSize: 18.sp,
                          color: isPrinterConnected
                              ? emeraldGreen
                              : amberWarning,
                        ),
                      ),
                      if (isPrinterConnected)
                        Text(
                          'Vendor ID: ${orderProvider.vendorId} | Product ID: ${orderProvider.productId}',
                          style: smallText.copyWith(
                            fontSize: 13.sp,
                            color: textDark,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Action Toolbar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'select_printer'.tr(),
                style: boldText.copyWith(fontSize: 19.sp, color: textDark),
              ),
              SizedBox(
                height: 46.h,
                child: PrimaryButton(
                  label: 'reload_printers'.tr(),
                  icon: Icons.refresh_rounded,
                  isLoading: _isLoading,
                  height: 46.h,
                  onPressed: _getDevicelist,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Device List
          if (devices.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: backgroundLight,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: borderSubtle),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.print_disabled_rounded,
                      size: 48.sp,
                      color: textMuted,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'printer_search_hint'.tr(),
                      textAlign: TextAlign.center,
                      style: mediumText.copyWith(
                        fontSize: 16.sp,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...devices.map((device) => _buildDeviceCard(device, orderProvider)),

          SizedBox(height: 24.h),
          const Divider(color: borderSubtle),
          SizedBox(height: 20.h),

          // POS Setup Button
          BorderButton(
            label: 'test_connection'.tr(),
            icon: Icons.point_of_sale_rounded,
            color: goSmartBlue,
            onPressed: () async {
              Map<String, dynamic> apiData = FawryHelper()
                  .setUpDataForFawryAPIFCRNInquiry('');
              Navigation().showLoadingGifDialog(context);
              await FawryHelper().fawryInquiryTest(apiData, context).then((
                map,
              ) {
                Navigation().closeDialog(context);
                showDialog(
                  context: context,
                  builder: (context) => OkDialog(
                    dialogText: '${map?['statusDescription'] ?? 'No Response'}',
                    onPressed: () => Navigation().closeDialog(context),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(
    Map<String, dynamic> device,
    OrdersProvider provider,
  ) {
    final vId = int.tryParse(device['vendorId']?.toString() ?? '') ?? 0;
    final pId = int.tryParse(device['productId']?.toString() ?? '') ?? 0;
    final isSelected =
        provider.vendorId == vId &&
        provider.productId == pId &&
        provider.isUSBPrinter;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isSelected ? goSmartBlue : borderSubtle,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: isSelected ? goSmartBlueLight : surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.print_rounded,
              color: isSelected ? goSmartBlue : textMedium,
              size: 26.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${device['manufacturer'] ?? ''} ${device['productName'] ?? 'Printer'}',
                  style: boldText.copyWith(fontSize: 18.sp, color: textDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'VID: ${device['vendorId']} • PID: ${device['productId']}',
                  style: smallText.copyWith(fontSize: 13.sp, color: textMuted),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? emeraldGreen : goSmartBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            ),
            onPressed: () async {
              int vendorId = int.parse(device['vendorId']);
              int productId = int.parse(device['productId']);
              bool? isConnected = await dragoUsbPrinter.connect(
                vendorId,
                productId,
              );
              if (isConnected ?? false) {
                if (context.mounted) {
                  context.read<OrdersProvider>().setPrinterManagerUSB =
                      dragoUsbPrinter;
                  context.read<OrdersProvider>().setVendorId = vendorId;
                  context.read<OrdersProvider>().setProductId = productId;
                  context.read<OrdersProvider>().setIsUSBPrinter = true;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم الاتصال بالطابعة بنجاح',
                        textAlign: TextAlign.center,
                        style: mediumText.copyWith(color: Colors.white),
                      ),
                      backgroundColor: emeraldGreen,
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  Navigation().closeDialog(context);
                }
              }
            },
            child: Text(
              isSelected ? 'متصل' : 'توصيل',
              style: boldText.copyWith(fontSize: 15.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
