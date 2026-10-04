import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/helpers/navigation_helper.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';
import 'package:gosmart_self_checkout/styles/text_style.dart';
import 'package:gosmart_self_checkout/widget/buttons.dart';
import 'package:provider/provider.dart';

class SearchForProductByBarcodeDialog extends StatefulWidget {
  const SearchForProductByBarcodeDialog({super.key});

  @override
  State<SearchForProductByBarcodeDialog> createState() =>
      _SearchForProductByBarcodeDialogState();
}

class _SearchForProductByBarcodeDialogState
    extends State<SearchForProductByBarcodeDialog> {
  String _barcode = '';

  void _onKeyPress(String value) {
    setState(() {
      if (value == 'C') {
        _barcode = '';
      } else if (value == 'BACK') {
        if (_barcode.isNotEmpty) {
          _barcode = _barcode.substring(0, _barcode.length - 1);
        }
      } else {
        if (_barcode.length < 18) {
          _barcode += value;
        }
      }
    });
  }

  void _submitBarcode() async {
    if (_barcode.trim().isEmpty) return;

    Navigation().showLoadingGifDialog(context);
    await context.read<OrdersProvider>().getProductDetailsByBarcode(
      _barcode.trim(),
    );
    if (mounted) {
      Navigation().closeDialog(context); // Close loading
      Navigation().closeDialog(context); // Close search dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      contentPadding: EdgeInsets.fromLTRB(28.w, 24.h, 28.w, 28.h),
      content: SizedBox(
        width: 440.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: goSmartBlueLight,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: goSmartBlue,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'enter_barcode'.tr(),
                      style: boldText.copyWith(
                        fontSize: 22.sp,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigation().closeDialog(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: textMuted,
                    size: 26.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Display Box
            Container(
              height: 70.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: surfaceMuted,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: _barcode.isNotEmpty ? goSmartBlue : borderSubtle,
                  width: 1.8,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _barcode.isEmpty ? '1234567890...' : _barcode,
                      style: boldText.copyWith(
                        fontSize: 28.sp,
                        color: _barcode.isEmpty ? textMuted : textDark,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_barcode.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.backspace_outlined,
                        color: dangerRed,
                        size: 22.sp,
                      ),
                      onPressed: () => _onKeyPress('BACK'),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Number Pad
            _buildNumpad(),
            SizedBox(height: 24.h),

            // Submit Button
            PrimaryButton(
              label: 'submit'.tr(),
              icon: Icons.search_rounded,
              height: 58.h,
              onPressed: _barcode.isNotEmpty ? _submitBarcode : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    final List<Map<String, dynamic>> keys = [
      {'val': '1', 'type': 'num'},
      {'val': '2', 'type': 'num'},
      {'val': '3', 'type': 'num'},
      {'val': '4', 'type': 'num'},
      {'val': '5', 'type': 'num'},
      {'val': '6', 'type': 'num'},
      {'val': '7', 'type': 'num'},
      {'val': '8', 'type': 'num'},
      {'val': '9', 'type': 'num'},
      {'val': 'C', 'type': 'clear'},
      {'val': '0', 'type': 'num'},
      {'val': 'BACK', 'type': 'back'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final keyItem = keys[index];
        final val = keyItem['val'] as String;
        final type = keyItem['type'] as String;

        Color bgColor = surfaceMuted;
        Color fgColor = textDark;

        if (type == 'clear') {
          bgColor = dangerRedLight;
          fgColor = dangerRed;
        } else if (type == 'back') {
          bgColor = amberWarningLight;
          fgColor = amberWarning;
        }

        return Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () => _onKeyPress(val),
            child: Center(
              child: type == 'back'
                  ? Icon(
                      Icons.backspace_rounded,
                      color: fgColor,
                      size: 24.sp,
                    )
                  : Text(
                      val,
                      style: boldText.copyWith(
                        fontSize: 26.sp,
                        color: fgColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
