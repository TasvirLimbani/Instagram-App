import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomToast {
  successToast({required BuildContext context, required String text}) {
    showTopSnackBar(
      displayDuration: Duration(milliseconds: 500),
      context,
      CustomSnackBar.success(
        message: text.toString(),
      ),
    );
  }

  infoToast({required BuildContext context, required String text}) {
    showTopSnackBar(
      // animationDuration: Duration(milliseconds:500),
      displayDuration: Duration(milliseconds: 500),
      context,
      CustomSnackBar.info(
        message: text.toString(),
      ),
    );
  }

  errorToast({required BuildContext context, required String text}) {
    showTopSnackBar(
      displayDuration: Duration(milliseconds: 500),
      context,
      CustomSnackBar.error(
        maxLines: 1,
        message: text.toString(),
      ),
    );
  }
}
