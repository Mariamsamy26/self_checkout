import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? height;
  final Gradient? gradient;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 58.h;
    final isEnabled = onPressed != null && !isLoading;

    return Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        gradient: isEnabled ? (gradient ?? goSmartGradient) : null,
        color: isEnabled ? null : borderSubtle,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: goSmartBlue.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 22.sp),
                          SizedBox(width: 10.w),
                        ],
                        Text(
                          label,
                          style: boldText.copyWith(
                            fontSize: 18.sp,
                            color: isEnabled ? Colors.white : textMuted,
                          ),
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

// Backward-compatible alias for existing code
class OrangeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const OrangeButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: label,
      onPressed: onPressed,
      gradient: goSmartGradient,
    );
  }
}

class GreyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const GreyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: surfaceMuted,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderSubtle, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textDark, size: 20.sp),
                  SizedBox(width: 8.w),
                ],
                Text(
                  label,
                  style: mediumText.copyWith(
                    fontSize: 17.sp,
                    color: textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const CancelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: dangerRedLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: dangerRed.withValues(alpha: 0.2), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: dangerRed, size: 20.sp),
                  SizedBox(width: 8.w),
                ],
                Text(
                  label,
                  style: boldText.copyWith(
                    fontSize: 17.sp,
                    color: dangerRed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisabledButton extends StatelessWidget {
  final String label;

  const DisabledButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: surfaceMuted,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Text(
          label,
          style: boldText.copyWith(fontSize: 17.sp, color: textMuted),
        ),
      ),
    );
  }
}

class BorderButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const BorderButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? goSmartBlue;
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: effectiveColor, width: 1.8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: effectiveColor, size: 20.sp),
                  SizedBox(width: 8.w),
                ],
                Text(
                  label,
                  style: boldText.copyWith(
                    fontSize: 17.sp,
                    color: effectiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
