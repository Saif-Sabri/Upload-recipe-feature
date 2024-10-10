import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

void requestPermissions() async {
  var camStatus = await Permission.camera.status;
  var locationStatus = await Permission.location.status;
  var storageStatus = await Permission.storage.status;
  var microphoneStatus = await Permission.microphone.status;
  if (camStatus.isDenied ||
      locationStatus.isDenied ||
      storageStatus.isDenied ||
      microphoneStatus.isDenied) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.microphone,
      Permission.camera
    ].request();
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    log(statuses.toString());
  }
}
