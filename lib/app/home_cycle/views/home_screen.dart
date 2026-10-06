import 'dart:async';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/app/home_cycle/widgets/cart_items_widget.dart';
import 'package:gosmart_self_checkout/app/home_cycle/widgets/payment_bottom_sheet.dart';
import 'package:gosmart_self_checkout/app/home_cycle/widgets/scanner_widget.dart';
import 'package:gosmart_self_checkout/app/home_cycle/widgets/usb_printer_setup_widget.dart';
import 'package:gosmart_self_checkout/helpers/application_dimentions.dart';
import 'package:gosmart_self_checkout/helpers/navigation_helper.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/buttons.dart';
import 'package:gosmart_self_checkout/widget/ok_dialog.dart';
import 'package:gosmart_self_checkout/widget/yes_no_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _toggleLanguage(BuildContext context) {
    if (context.locale.languageCode == 'ar') {
      context.setLocale(const Locale('en'));
    } else {
      context.setLocale(const Locale('ar'));
    }
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => YesNoDialog(
            dialogText: 'confirm_clear_cart'.tr(),
            isDestructive: true,
            onYesPressed: () {
              context.read<OrdersProvider>().clearCartAndResetAll();
              Navigation().closeDialog(context);
            },
            onNoPressed: () => Navigation().closeDialog(context),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);
    final orderProvider = context.watch<OrdersProvider>();

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Modern Kiosk Header
                _buildHeader(context, orderProvider),

                // Scanner Section
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: borderSubtle),
                      boxShadow: [
                        BoxShadow(
                          color: textDark.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const ScannerWidget(),
                  ),
                ),

                // Cart Items Section
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                      border: Border.all(color: borderSubtle),
                      boxShadow: [
                        BoxShadow(
                          color: textDark.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'your_cart'.tr(),
                                    style: boldText.copyWith(
                                      fontSize: 22.sp,
                                      color: textDark,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: goSmartBlueLight,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      '${orderProvider.cartItems.length} ${'items_count'.tr()}',
                                      style: boldText.copyWith(
                                        fontSize: 14.sp,
                                        color: goSmartBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (orderProvider.cartItems.isNotEmpty)
                                TextButton.icon(
                                  onPressed: () => _confirmClearCart(context),
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18.sp,
                                    color: dangerRed,
                                  ),
                                  label: Text(
                                    'clear_cart'.tr(),
                                    style: mediumText.copyWith(
                                      fontSize: 14.sp,
                                      color: dangerRed,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: borderSubtle),
                        const Expanded(child: CartItemsWidget()),
                      ],
                    ),
                  ),
                ),

                // Docked Bottom Checkout Section
                _buildCheckoutSection(context, orderProvider),
              ],
            ),

            // Hidden Screenshot widget for receipt printing
            _buildHiddenReceipt(context, orderProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OrdersProvider orderProvider) {
    final isArabic = context.locale.languageCode == 'ar';
    final isPrinterConnected =
        orderProvider.isUSBPrinter &&
        orderProvider.vendorId != 0 &&
        orderProvider.productId != 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 18.h),
      decoration: BoxDecoration(
        gradient: goSmartGradient,
        boxShadow: [
          BoxShadow(
            color: goSmartBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand & Terminal Info
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/blubite_trans.png',
                      height: 42.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BluBite',
                        style: boldText.copyWith(
                          fontSize: 22.sp,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '${'kiosk_terminal'.tr()} • #${orderProvider.branchId}',
                        style: smallText.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Live Digital Clock & Date
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      ez.DateFormat('hh:mm a').format(_currentTime),
                      style: boldText.copyWith(
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '•  ${ez.DateFormat(isArabic ? 'd MMM' : 'MMM d').format(_currentTime)}',
                      style: smallText.copyWith(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),

              // Actions: Language Toggle & Hardware Status & Settings
              Row(
                children: [
                  // Language Switcher
                  Material(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () => _toggleLanguage(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.language_rounded,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              isArabic ? 'English' : 'عربي',
                              style: boldText.copyWith(
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // Printer Status Pill
                  Material(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () => _openHardwareSetup(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.r,
                              height: 10.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    isPrinterConnected
                                        ? emeraldGreen
                                        : amberWarning,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isPrinterConnected
                                            ? emeraldGreen
                                            : amberWarning)
                                        .withValues(alpha: 0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.print_rounded,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, OrdersProvider provider) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: borderSubtle, width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: textDark.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total Amount Breakdown
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total_amount'.tr(),
                  style: smallText.copyWith(fontSize: 15.sp, color: textMuted),
                ),
                SizedBox(height: 2.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      provider.cartTotal.toStringAsFixed(2),
                      style: boldText.copyWith(
                        fontSize: 34.sp,
                        color: goSmartBlue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'egp'.tr(),
                      style: boldText.copyWith(
                        fontSize: 18.sp,
                        color: goSmartBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),

          // Pay and Finish Button
          Expanded(
            flex: 4,
            child: PrimaryButton(
              label: 'finish_order'.tr(),
              icon: Icons.payment_rounded,
              height: 64.h,
              gradient: provider.cartItems.isNotEmpty ? bluBiteGradient : null,
              onPressed:
                  provider.cartItems.isNotEmpty
                      ? () => _handleCheckout(context, provider)
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context, OrdersProvider provider) {
    if (provider.cartItems.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => OkDialog(
              dialogText: 'cart_empty'.tr(),
              onPressed: () => Navigation().closeDialog(context),
            ),
      );
      return;
    }

    if (provider.vendorId == 0 || provider.productId == 0) {
      showDialog(
        context: context,
        builder:
            (context) => OkDialog(
              dialogText: 'من فضلك تأكد من الاتصال بالطابعة أولاً',
              onPressed: () {
                Navigation().closeDialog(context);
                _openHardwareSetup(context);
              },
            ),
      );
      return;
    }

    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PaymentBottomSheet(screenshotController: screenshotController);
      },
    );
  }

  void _openHardwareSetup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            content: SizedBox(
              height: AppDimentions().availableheightNoAppBar * 0.75,
              width: AppDimentions().availableWidth * 0.85,
              child: const USBPrinterSetupWidget(),
            ),
          ),
    );
  }

  Widget _buildHiddenReceipt(BuildContext context, OrdersProvider provider) {
    return Positioned(
      left: -3000,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Screenshot(
          controller: screenshotController,
          child: Directionality(
            textDirection:
                context.locale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(14),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'BluBite',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Self Checkout Receipt',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  const Divider(color: Colors.black26),
                  Row(
                    children: [
                      const Text(
                        'Date: ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        ez.DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...provider.cartItems.map((item) {
                    final product = item.data!.first;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            '${product.selectedQty.toInt()}x ',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              product.nameAr ?? product.name ?? '',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ((product.listPrice ?? 0) * product.selectedQty)
                                .toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(color: Colors.black26),
                  Row(
                    children: [
                      const Text(
                        'TOTAL:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${provider.cartTotal.toStringAsFixed(2)} EGP',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Thank you for shopping with us!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
