import 'dart:async';
import 'package:barcode_input_listener/barcode_input_listener.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/app/home_cycle/dialogs/search_for_product_by_barcode_dialog.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/buttons.dart';
import 'package:gosmart_self_checkout/widget/custom_cached_image.dart';
import 'package:provider/provider.dart';

class ScannerWidget extends StatefulWidget {
  const ScannerWidget({super.key});

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget>
    with SingleTickerProviderStateMixin {
  String _scannedBarcode = '';
  Timer? _barcodeDebounce;
  String _currentBuffer = '';
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    _barcodeDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProviderWatch = context.watch<OrdersProvider>();

    return BarcodeInputListener(
      useKeyDownEvent: true,
      onBarcodeScanned: (barcode) async {
        String scanned = barcode;
        _currentBuffer = scanned;
        _barcodeDebounce?.cancel();
        _barcodeDebounce = Timer(const Duration(milliseconds: 300), () async {
          setState(() {
            _scannedBarcode = _currentBuffer;
          });
          await context.read<OrdersProvider>().getProductDetailsByBarcode(
            _scannedBarcode,
          );
          _currentBuffer = '';
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        child: Column(
          children: [
            Expanded(child: _buildContent(orderProviderWatch)),
            SizedBox(height: 10.h),
            _buildSearchButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(OrdersProvider provider) {
    if (!provider.dataLoaded) {
      return _buildInitialState();
    }
    if (provider.productByBarcode.data == null ||
        provider.productByBarcode.data!.isEmpty) {
      return _buildNotFoundState();
    }
    return _buildProductFoundState(provider);
  }

  Widget _buildInitialState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundLight,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderSubtle, width: 1.5),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Scanner Laser Line
              AnimatedBuilder(
                animation: _laserAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: _laserAnimation.value * (constraints.maxHeight - 16.h),
                    left: 16.w,
                    right: 16.w,
                    child: Container(
                      height: 3.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            goSmartBlue.withValues(alpha: 0.8),
                            goSmartCyan,
                            goSmartBlue.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: goSmartCyan.withValues(alpha: 0.6),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Corner Reticle Brackets
              _buildCornerBracket(isTop: true, isLeft: true),
              _buildCornerBracket(isTop: true, isLeft: false),
              _buildCornerBracket(isTop: false, isLeft: true),
              _buildCornerBracket(isTop: false, isLeft: false),

              // Center Visual inside FittedBox to prevent any overflow
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: goSmartBlue.withValues(alpha: 0.12),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/barcode-reader.png',
                          width: 56.w,
                          height: 56.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'scan_for_start'.tr(),
                        style: boldText.copyWith(
                          fontSize: 20.sp,
                          color: textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'scan_barcode_hint'.tr(),
                        style: smallText.copyWith(
                          fontSize: 14.sp,
                          color: textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotFoundState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: dangerRedLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: dangerRed.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: dangerRed.withValues(alpha: 0.15),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 40.sp,
                  color: dangerRed,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'product_not_found'.tr(),
                style: boldText.copyWith(
                  color: dangerRed,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'scan_barcode_hint'.tr(),
                style: smallText.copyWith(
                  fontSize: 13.sp,
                  color: textMedium,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductFoundState(OrdersProvider provider) {
    final product = provider.productByBarcode.data!.first;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: emeraldGreen.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: emeraldGreen.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image Thumbnail
              Container(
                width: 90.w,
                height: 90.w,
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: backgroundLight,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: borderSubtle),
                ),
                child: CustomCachedImage(
                  imageUrl: product.image ?? '',
                  borderRadius: 10.r,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 14.w),

              // Details Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: emeraldGreenLight,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: emeraldGreen,
                          size: 13.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'product_found'.tr(),
                          style: smallText.copyWith(
                            color: emeraldGreen,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Product Name
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 240.w),
                    child: Text(
                      product.nameAr ?? product.name ?? '',
                      style: boldText.copyWith(
                        fontSize: 18.sp,
                        color: textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Price
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${product.listPrice} ',
                        style: boldText.copyWith(
                          color: coralOrange,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'egp'.tr(),
                        style: mediumText.copyWith(
                          color: coralOrange,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return PrimaryButton(
      label: 'search_for_item'.tr(),
      icon: Icons.keyboard_alt_outlined,
      height: 50.h,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const SearchForProductByBarcodeDialog(),
        );
      },
    );
  }

  Widget _buildCornerBracket({
    required bool isTop,
    required bool isLeft,
  }) {
    return Positioned(
      top: isTop ? 10.h : null,
      bottom: !isTop ? 10.h : null,
      left: isLeft ? 12.w : null,
      right: !isLeft ? 12.w : null,
      child: Container(
        width: 18.w,
        height: 18.w,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: bluBiteCyan, width: 3)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: bluBiteCyan, width: 3)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: bluBiteCyan, width: 3)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: bluBiteCyan, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
