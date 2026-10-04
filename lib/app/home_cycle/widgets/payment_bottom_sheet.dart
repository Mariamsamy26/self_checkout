import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/app/home_cycle/widgets/credit_card_guide_dialog.dart';
import 'package:gosmart_self_checkout/helpers/navigation_helper.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class PaymentBottomSheet extends StatelessWidget {
  final ScreenshotController screenshotController;

  const PaymentBottomSheet({super.key, required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrdersProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(28.w, 16.h, 28.w, 36.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: borderStrong,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'checkout'.tr(),
                  style: displayLarge.copyWith(
                    fontSize: 28.sp,
                    color: textDark,
                  ),
                ),
                Material(
                  color: surfaceMuted,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => Navigation().closeDialog(context),
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.close_rounded,
                        size: 26.sp,
                        color: textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Order Total Banner
            Container(
              padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    goSmartBlueLight,
                    goSmartBlue.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: goSmartBlue.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'total_due'.tr(),
                        style: mediumText.copyWith(
                          fontSize: 16.sp,
                          color: textMedium,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${orderProvider.cartItems.length} ${'items_count'.tr()}',
                        style: smallText.copyWith(
                          fontSize: 14.sp,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        orderProvider.cartTotal.toStringAsFixed(2),
                        style: boldText.copyWith(
                          fontSize: 38.sp,
                          color: goSmartBlue,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'egp'.tr(),
                        style: boldText.copyWith(
                          fontSize: 20.sp,
                          color: goSmartBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // Section Label
            Text(
              'select_payment_method'.tr(),
              style: mediumText.copyWith(
                fontSize: 18.sp,
                color: textMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),

            // Credit / Debit Card Payment Option Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: goSmartBlue, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: goSmartBlue.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24.r),
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => CreditPaymentGuideDialog(
                        screenshotController: screenshotController,
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Row(
                      children: [
                        // Card / POS Illustration
                        Container(
                          width: 80.w,
                          height: 80.w,
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: goSmartBlueLight,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Image.asset(
                            'assets/images/pos_payment.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 20.w),

                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'credit_card'.tr(),
                                style: boldText.copyWith(
                                  fontSize: 22.sp,
                                  color: textDark,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'tap_card_hint'.tr(),
                                style: smallText.copyWith(
                                  fontSize: 14.sp,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Forward indicator
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: goSmartBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 28.h),

            // Security Badge
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 16.sp,
                    color: textMuted,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'معاملة مصرفية مشفرة وآمنة بالكامل',
                    style: smallText.copyWith(
                      fontSize: 13.sp,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
