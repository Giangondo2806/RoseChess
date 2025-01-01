import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

void toast({
required BuildContext context, 
required String title,
required String description,
required ToastificationType type,
}) {
  toastification.show(
      context: context,
      title: Text(title),
      description: Text(description),
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.centerRight,
      autoCloseDuration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Bắt đầu từ bên phải
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
      showProgressBar: false);
}
