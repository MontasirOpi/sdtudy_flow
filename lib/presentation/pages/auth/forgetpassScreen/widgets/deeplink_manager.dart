import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkManager {
  DeepLinkManager._privateConstructor();

  static final DeepLinkManager instance = DeepLinkManager._privateConstructor();

  Stream<Uri?>? _linkStream;

  void init(BuildContext context) {
    _linkStream ??= uriLinkStream;

    _linkStream!.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'myapp') {
        switch (uri.host) {
          case 'reset-password':
            context.go('/reset-password');
            break;
          // future: handle other deep links here
        }
      }
    });
  }
}
