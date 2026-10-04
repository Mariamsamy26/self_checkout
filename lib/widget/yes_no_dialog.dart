import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/buttons.dart';

class YesNoDialog extends StatelessWidget {
  final String dialogText;
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;
  final bool isDestructive;

  const YesNoDialog({
    super.key,
    required this.dialogText,
    required this.onYesPressed,
    required this.onNoPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      contentPadding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 24.h),
      content: SizedBox(
        width: 480.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: isDestructive ? dangerRedLight : amberWarningLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDestructive
                    ? Icons.delete_outline_rounded
                    : Icons.help_outline_rounded,
                size: 40.sp,
                color: isDestructive ? dangerRed : amberWarning,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              dialogText,
              textAlign: TextAlign.center,
              style: boldText.copyWith(
                fontSize: 22.sp,
                color: textDark,
                height: 1.4,
              ),
            ),
            SizedBox(height: 28.h),
            Row(
              children: [
                Expanded(
                  child: GreyButton(
                    label: 'no'.tr(),
                    onPressed: onNoPressed,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: isDestructive
                      ? CancelButton(
                          label: 'yes'.tr(),
                          onPressed: onYesPressed,
                        )
                      : PrimaryButton(
                          label: 'yes'.tr(),
                          onPressed: onYesPressed,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
