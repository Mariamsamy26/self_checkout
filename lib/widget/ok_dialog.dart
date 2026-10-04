import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/buttons.dart';

class OkDialog extends StatelessWidget {
  final String dialogText;
  final VoidCallback onPressed;
  final IconData icon;

  const OkDialog({
    super.key,
    required this.dialogText,
    required this.onPressed,
    this.icon = Icons.info_outline_rounded,
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
                color: goSmartBlueLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 42.sp, color: goSmartBlue),
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
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'ok'.tr(),
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
