import 'package:flutter/material.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:38
 * Project Name: IntelliJ IDEA
 * File Name: error_dialog


 */

class ErrorDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry!();
            },
            child: Text('Retry'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}