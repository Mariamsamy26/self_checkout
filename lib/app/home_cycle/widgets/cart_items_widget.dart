import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/custom_cached_image.dart';
import 'package:provider/provider.dart';

class CartItemsWidget extends StatelessWidget {
  const CartItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<OrdersProvider>().cartItems;

    if (cartItems.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: coralOrangeLight.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/EmptyState.png',
                    width: 90.w,
                    height: 90.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'cart_empty'.tr(),
                  style: boldText.copyWith(
                    color: textDark,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'scan_or_search'.tr(),
                  textAlign: TextAlign.center,
                  style: smallText.copyWith(
                    color: textMuted,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        final product = item.data!.first;
        final isArabic = context.locale.languageCode == 'ar';
        final lineTotal = (product.listPrice ?? 0) * product.selectedQty;

        return Container(
          margin: EdgeInsets.only(bottom: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderSubtle, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: textDark.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Thumbnail
                Container(
                  width: 96.w,
                  height: 96.w,
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: backgroundLight,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: borderSubtle),
                  ),
                  child: CustomCachedImage(
                    imageUrl: product.image ?? '',
                    borderRadius: 12.r,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 16.w),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (isArabic ? product.nameAr : product.name) ??
                            product.nameAr ??
                            product.name ??
                            '',
                        style: boldText.copyWith(
                          fontSize: 19.sp,
                          color: textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${product.listPrice} ${'egp'.tr()} / ${'units'.tr()}',
                        style: smallText.copyWith(
                          fontSize: 14.sp,
                          color: textMuted,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${lineTotal.toStringAsFixed(2)} ${'egp'.tr()}',
                        style: boldText.copyWith(
                          fontSize: 22.sp,
                          color: coralOrange,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity Stepper
                Container(
                  decoration: BoxDecoration(
                    color: surfaceMuted,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: borderSubtle),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Minus or Trash
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context
                              .read<OrdersProvider>()
                              .decreaseProductQuantity(item),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              color: product.selectedQty == 1
                                  ? dangerRedLight
                                  : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              product.selectedQty == 1
                                  ? Icons.delete_outline_rounded
                                  : Icons.remove_rounded,
                              size: 20.sp,
                              color: product.selectedQty == 1
                                  ? dangerRed
                                  : textDark,
                            ),
                          ),
                        ),
                      ),

                      // Quantity text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Text(
                          '${product.selectedQty.toInt()}',
                          style: boldText.copyWith(
                            fontSize: 20.sp,
                            color: textDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      // Plus
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context
                              .read<OrdersProvider>()
                              .increaseProductQuantity(item),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              color: goSmartBlue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: goSmartBlue.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              size: 22.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
