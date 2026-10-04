import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/helpers/navigation_helper.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/buttons.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class OrderCompletedDialog extends StatefulWidget {
  final ScreenshotController screenshotController;

  const OrderCompletedDialog({super.key, required this.screenshotController});

  @override
  State<OrderCompletedDialog> createState() => _OrderCompletedDialogState();
}

class _OrderCompletedDialogState extends State<OrderCompletedDialog> {
  bool _isPrinting = false;

  void _finishAndClose() {
    context.read<OrdersProvider>().clearCartAndResetAll();
    Navigation().closeDialog(context); // Close completed dialog
    Navigation().closeDialog(context); // Close guide dialog
    Navigation().closeDialog(context); // Close payment sheet
  }

  void _print() async {
    setState(() => _isPrinting = true);
    await context.read<OrdersProvider>().printReceipt(
      widget.screenshotController,
      context.read<OrdersProvider>().isUSBPrinter,
    );
    if (mounted) {
      setState(() => _isPrinting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'جاري طباعة الإيصال...',
            textAlign: TextAlign.center,
            style: mediumText.copyWith(color: Colors.white),
          ),
          backgroundColor: goSmartBlue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrdersProvider>();

    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
        ),
        contentPadding: EdgeInsets.fromLTRB(36.w, 36.h, 36.w, 36.h),
        content: SizedBox(
          width: 520.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration Badge
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  gradient: successGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: emeraldGreen.withValues(alpha: 0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 56.sp,
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                'thank_you'.tr(),
                textAlign: TextAlign.center,
                style: displayLarge.copyWith(
                  fontSize: 34.sp,
                  color: textDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'order_accepted'.tr(),
                textAlign: TextAlign.center,
                style: mediumText.copyWith(
                  fontSize: 18.sp,
                  color: textMedium,
                ),
              ),
              SizedBox(height: 24.h),

              // Summary Info Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: backgroundLight,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'total_amount'.tr(),
                          style: smallText.copyWith(
                            fontSize: 14.sp,
                            color: textMuted,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${orderProvider.cartTotal.toStringAsFixed(2)} ${'egp'.tr()}',
                          style: boldText.copyWith(
                            fontSize: 22.sp,
                            color: goSmartBlue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: emeraldGreenLight,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: emeraldGreen,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'paid'.tr(gender: 'paid'),
                            style: smallText.copyWith(
                              color: emeraldGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Action Buttons
              PrimaryButton(
                label: 'print_receipt'.tr(),
                icon: Icons.print_rounded,
                isLoading: _isPrinting,
                gradient: successGradient,
                height: 58.h,
                onPressed: _print,
              ),
              SizedBox(height: 14.h),

              BorderButton(
                label: 'new_order'.tr(),
                icon: Icons.refresh_rounded,
                color: goSmartBlue,
                onPressed: _finishAndClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
