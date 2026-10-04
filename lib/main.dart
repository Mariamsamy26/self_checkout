import 'dart:async';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gosmart_self_checkout/app/home_cycle/providers/orders_provider.dart';
import 'package:gosmart_self_checkout/app/home_cycle/views/splash_screen.dart';
import 'package:provider/provider.dart';
import 'styles/colors.dart';
import 'package:easy_localization/easy_localization.dart' as loc;

int posId = 3;
int currencyId = 74;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  //* ENABLE ACCEPT CERTIFICATES
  HttpOverrides.global = MyHttpOverrides();

  await loc.EasyLocalization.ensureInitialized();

  runApp(
    loc.EasyLocalization(
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar', ''),
      startLocale: const Locale('ar', ''),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<OrdersProvider>(
            create: (_) => OrdersProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1500, 800), //* TABLET KIOSK
      minTextAdapt: true,
      builder: (context, child) {
        final isArabic = context.locale.languageCode == 'ar';
        return MaterialApp(
          title: 'GoSmart Self-Checkout',
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: widget!,
              ),
            );
          },
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: GoogleFonts.cairo().fontFamily,
            scaffoldBackgroundColor: backgroundLight,
            colorScheme: ColorScheme.fromSeed(
              seedColor: goSmartBlue,
              primary: goSmartBlue,
              secondary: goSmartCyan,
              surface: Colors.white,
              brightness: Brightness.light,
            ),
            appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(color: textDark),
              centerTitle: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              titleTextStyle: TextStyle(
                fontFamily: GoogleFonts.cairo().fontFamily,
                fontSize: 22.sp,
                color: textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: const BorderSide(color: borderSubtle, width: 1),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: goSmartBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.cairo().fontFamily,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(color: borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(color: borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(color: goSmartBlue, width: 2),
              ),
              filled: true,
              fillColor: surfaceMuted,
            ),
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
