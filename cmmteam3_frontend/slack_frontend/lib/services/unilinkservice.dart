import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/screens/Welcome/welcome_screen.dart';
import 'package:flutter_frontend/screens/confirmInvitation/member_confirm_invitation.dart';
import 'package:flutter_frontend/services/contextutility.dart';

import 'package:uni_links/uni_links.dart';

// Authorname-NayLinMyat@CyberMissions Myanmar Company limited

class UniServices {
  static String _path = '';
  static String get path => _path;
  static bool get hasPath => _path.isNotEmpty;
  static String? receivedPath;
  static String? workspaceId;
  static String? channelId;
  static String? email;

  static void reset() => _path = '';

  static init() async {
    try {
      final Uri? uri = await getInitialUri();
      uniHandler(uri);
    } on PlatformException {
      log("Failed to receive the path!");
    } on FormatException {
      log("Wrong format path received!");
    }

    uriLinkStream.listen((Uri? uri) async {
      uniHandler(uri);
    }, onError: (error) {
      log("OnUriLink Error: $error");
    });
  }

  static uniHandler(Uri? uri) {
    if (uri == null || uri.queryParameters.isEmpty) return;

    Map<String, String> param = uri.queryParameters;
    String? receivedPath = param['path'];
    String? workspaceId = param['workspaceId'];
    String? channelId = param['channelId'];
    String? email = param['email'];

    if (receivedPath == "confirminvitation") {
      // Ensure workspaceId, channelId, and email are not null before proceeding
      if (workspaceId != null && channelId != null && email != null) {
        int intWorkspaceId = int.tryParse(workspaceId) ?? 0;
        int intChannelId = int.tryParse(channelId) ?? 0;

        Navigator.push(
          ContextUtility.context!,
          MaterialPageRoute(
            builder: (_) => ConfirmPage(
              workspaceId: intWorkspaceId,
              channelId: intChannelId,
              email: email,
            ),
          ),
        );
      } else {
        // Handle missing parameters
        print("Error: Required parameters missing for confirmation.");
      }
    } else {
      // Handle other paths (if needed)
      print("Unhandled path: $receivedPath");
    }
  }
}
