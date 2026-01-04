import 'dart:async';
import 'package:flutter/material.dart';

/// كلاس مساعد لتحويل Stream (مثل Bloc Stream) إلى Listenable
/// يستخدمه GoRouter لإعادة تقييم التوجيه (Redirect) عند تغير الحالة
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}