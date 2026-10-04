import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gosmart_self_checkout/styles/colors.dart';

TextStyle get smallText => GoogleFonts.cairo(
  fontSize: 14.sp,
  color: textMedium,
  fontWeight: FontWeight.w500,
);

TextStyle get mediumText => GoogleFonts.cairo(
  fontSize: 18.sp,
  color: textDark,
  fontWeight: FontWeight.w600,
);

TextStyle get boldText => GoogleFonts.cairo(
  fontSize: 20.sp,
  color: textDark,
  fontWeight: FontWeight.w700,
);

TextStyle get displayLarge => GoogleFonts.cairo(
  fontSize: 34.sp,
  color: textDark,
  fontWeight: FontWeight.w800,
  letterSpacing: -0.5,
);

TextStyle get headingLarge => GoogleFonts.cairo(
  fontSize: 26.sp,
  color: textDark,
  fontWeight: FontWeight.w700,
);

TextStyle get headingMedium => GoogleFonts.cairo(
  fontSize: 22.sp,
  color: textDark,
  fontWeight: FontWeight.w700,
);

TextStyle get priceLarge => GoogleFonts.cairo(
  fontSize: 32.sp,
  color: goSmartBlue,
  fontWeight: FontWeight.w900,
);

TextStyle get appBarStyle => GoogleFonts.cairo(
  fontSize: 22.sp,
  color: textDark,
  fontWeight: FontWeight.w700,
);

TextStyle get smallTextReceipt => GoogleFonts.cairo(
  fontSize: 12.sp,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

// Modern Borders
var textBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16.r),
  borderSide: const BorderSide(color: borderSubtle, width: 1.5),
);

var loginRegisterTextBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16.r),
  borderSide: const BorderSide(color: borderSubtle, width: 1.5),
);

var searchTextBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16.r),
  borderSide: BorderSide.none,
);
