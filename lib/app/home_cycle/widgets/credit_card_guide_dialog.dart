import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/app/home_cycle/dialogs/order_completed_dialog.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/helpers/fawry_helper.dart';
import 'package:gosmart_self_checkout/helpers/navigation_helper.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/buttons.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../views/splash_screen.dart';

class CreditPaymentGuideDialog extends StatefulWidget {
  final ScreenshotController screenshotController;

  const CreditPaymentGuideDialog({
    super.key,
    required this.screenshotController,
  });

  @override
  State<CreditPaymentGuideDialog> createState() =>
      _CreditPaymentGuideDialogState();
}

class _CreditPaymentGuideDialogState extends State<CreditPaymentGuideDialog> {
  bool finishOrder = false;
  String paymentStatus = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      initPayment();
    });
  }

  void initPayment() async {
    setState(() {
      paymentStatus = '';
      finishOrder = false;
    });

    Navigation().showLoadingGifDialog(context);

    Map<String, dynamic> apiData = FawryHelper().setUpDataForFawryAPIPurchase(
      context.read<OrdersProvider>().cartTotal,
    );

    await FawryHelper().fawryPurchase(apiData, context).then((value) async {
      log('STATUS: ${value.toString()}');

      if (value == 'Payment.VALUE_PAYMENT_STATUS_SUCCESS') {
        finishOrder = true;
        setState(() {});

        if (mounted) {
          Navigation().closeDialog(context); // Close loading dialog
        }

        await context.read<OrdersProvider>().submitOrder();

        await context.read<OrdersProvider>().printReceipt(
          widget.screenshotController,
          context.read<OrdersProvider>().isUSBPrinter,
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => OrderCompletedDialog(
                screenshotController: widget.screenshotController,
              ),
            );
          }
        });
      } else {
        if (mounted) {
          Navigation().closeDialog(context); // Close loading
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(value ?? '')));
          setState(() {
            paymentStatus = value ?? 'Failed';
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartTotal = context.watch<OrdersProvider>().cartTotal;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        contentPadding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 32.h),
        content: SizedBox(
          width: 520.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Text(
                'please_pay_with_card'.tr(),
                textAlign: TextAlign.center,
                style: boldText.copyWith(fontSize: 24.sp, color: textDark),
              ),
              SizedBox(height: 12.h),

              // Total Amount Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: goSmartBlueLight,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${cartTotal.toStringAsFixed(2)} ${'egp'.tr()}',
                  style: boldText.copyWith(
                    fontSize: 26.sp,
                    color: goSmartBlue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Interactive Graphic Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: backgroundLight,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: borderSubtle),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/pos_payment.png',
                      height: 160.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20.h),

                    // Status Message
                    if (finishOrder) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: emeraldGreen,
                            size: 26.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'payment_is_succeess'.tr(),
                            style: boldText.copyWith(
                              fontSize: 20.sp,
                              color: emeraldGreen,
                            ),
                          ),
                        ],
                      ),
                    ] else if (paymentStatus.isEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                goSmartBlue,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Flexible(
                            child: Text(
                              'please_wait_seconds'.tr(),
                              style: mediumText.copyWith(
                                fontSize: 16.sp,
                                color: textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        _getFormattedError(paymentStatus),
                        style: boldText.copyWith(
                          fontSize: 18.sp,
                          color: dangerRed,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 28.h),

              // Action buttons if error occurred
              if (paymentStatus.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: CancelButton(
                        label: 'cancel'.tr(),
                        icon: Icons.close_rounded,
                        onPressed: () {
                          Navigation().goToScreenAndClearAll(
                            context,
                            (context) => const SplashScreen(),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: PrimaryButton(
                        label: 'try_again'.tr(),
                        icon: Icons.refresh_rounded,
                        onPressed: () => initPayment(),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getFormattedError(String status) {
    if (status == 'تم إلغاء المعاملة' || status == 'عملية ملغاة') {
      return 'payment_is_cancelled'.tr();
    }
    if (status.contains('لا يمكن الوصول للخادم')) {
      return 'please_login_check_connection'.tr();
    }
    return status;
  }
}
