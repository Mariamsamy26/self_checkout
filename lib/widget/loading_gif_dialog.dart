import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingGifDialog extends StatelessWidget {
  const LoadingGifDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 64.h,
                width: 64.w,
                child: const LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: [goSmartBlue, goSmartCyan, emeraldGreen],
                  strokeWidth: 2,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'please_wait_seconds'.tr(),
                textAlign: TextAlign.center,
                style: mediumText.copyWith(
                  fontSize: 18.sp,
                  color: textDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
