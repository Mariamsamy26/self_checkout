import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gosmart_self_checkout/widget/error_dialog_api.dart';
import 'package:gosmart_self_checkout/helpers/navigation_helper.dart';

class ApiHelper {
  static Future<T?> runApiWithLoading<T>({
    required BuildContext context,
    required Future<T> Function() request,
    void Function(T result)? onSuccess,
  }) async {
    Navigation().showLoadingGifDialog(context);

    T? result;
    Object? error;

    try {
      result = await request();
    } catch (e, stackTrace) {
      error = e;

      debugPrint('API Handler Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (context.mounted) {
        Navigation().closeDialog(context);
      }
    }

    if (!context.mounted) {
      return result;
    }

    // ============================================================
    // EXCEPTION / NETWORK / TECHNICAL ERROR
    // ============================================================
    if (error != null) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return ApiErrorDialog(
            message: 'something_wrong_happened'.tr(),
            errorDetails: error.toString(),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          );
        },
      );

      return null;
    }

    // ============================================================
    // NULL RESPONSE
    // ============================================================
    if (result == null) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return ApiErrorDialog(
            message: 'something_wrong_happened'.tr(),
            errorDetails: 'API returned null response',
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          );
        },
      );

      return null;
    }

    // ============================================================
    // SUCCESSFUL API CALL
    // ============================================================
    onSuccess?.call(result);

    return result;
  }
}
