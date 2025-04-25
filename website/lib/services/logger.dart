import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'api_manager.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

Future<void> handleApiError({
  required BuildContext context,
  required ApiResponse response,
  String message = "",
  bool showToUser = true,
}) async {
  if (response.success) {
    return;
  }

  final errorCode = response.statusCode;
  final shortMessage =
      response.error ?? response.body['error'] ?? 'Упс... Что-то пошло не так';

  logError(errorCode, shortMessage, response.body);

  if (showToUser && context.mounted) {
    await showErrorToUser(context, errorCode, shortMessage);
  }
}

void logError(int errorCode, String errorMessage, Map<String, dynamic> body) {
  if (body.keys.contains('error')) body.remove('error');
  final errorDetails = {
    'code': errorCode,
    'message': errorMessage,
    'body': body,
    'timestamp': DateTime.now().toIso8601String(),
  };

  _logger.e('API Error', error: errorDetails);
}

Future<void> showErrorToUser(
  BuildContext context,
  dynamic errorCode,
  String errorMessage,
) async {
  if (errorCode != -1) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$errorMessage (Error $errorCode)'),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$errorMessage'),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
