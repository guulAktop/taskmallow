import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:taskmallow/repositories/user_repository.dart';

class AppFunctions {
  void showSnackbar(BuildContext context, String text, {Color? backgroundColor, CustomIconData? icon, int duration = 2}) {
    final snackbar = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Row(
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  child: IconComponent(iconData: icon, size: 24, color: Colors.white),
                )
              : const SizedBox(),
          Expanded(
            child: Text(
              text,
              textAlign: icon != null ? TextAlign.start : TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor != null ? backgroundColor.withOpacity(1) : Colors.grey.withOpacity(1),
      duration: Duration(seconds: duration),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  showProgressDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (context) {
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  void showMediaSnackbar(BuildContext context, Function cameraFunction, Function galleryFunction) {
    final snackbar = SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              splashColor: secondaryColor,
              iconSize: UIHelper.getDeviceWidth(context) / 8,
              onPressed: () {
                cameraFunction();
              },
              icon: IconComponent(
                iconData: CustomIconData.camera,
                color: Colors.white,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              splashColor: secondaryColor,
              iconSize: UIHelper.getDeviceWidth(context) / 8,
              onPressed: () {
                galleryFunction();
              },
              icon: IconComponent(
                iconData: CustomIconData.image,
                color: Colors.white,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
            ),
          )
        ],
      ),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: primaryColor,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  Future<File?> pickImageFromGallery() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    try {
      PermissionStatus permissionStatus = PermissionStatus.denied;
      if (int.parse(androidInfo.version.release) >= 12) {
        await Permission.photos.request();
        permissionStatus = await Permission.photos.status;
      } else {
        await Permission.storage.request();
        permissionStatus = await Permission.storage.status;
      }
      if (permissionStatus.isGranted) {
        try {
          final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 75, maxWidth: 1000);
          if (image == null) return null;
          final imageTemp = File(image.path);
          return imageTemp;
        } on PlatformException catch (e) {
          debugPrint('Failed to pick image: $e');
          return null;
        }
      } else {
        debugPrint('$permissionStatus');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<File?> pickImageFromCamera() async {
    try {
      await Permission.camera.request();
      var permissionStatus = await Permission.camera.status;
      if (permissionStatus.isGranted) {
        try {
          final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 75, maxWidth: 1000);
          if (image == null) return null;
          final imageTemp = File(image.path);
          return imageTemp;
        } on PlatformException catch (e) {
          debugPrint('Failed to pick image: $e');
          return null;
        }
      } else {
        debugPrint('$permissionStatus');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  int generateCode() {
    int randomCode = Random().nextInt(900000) + 100000;
    return randomCode;
  }

  Future<bool> sendVerificationCode(String toMail, String code) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('sendVerificationCode').call(<String, dynamic>{'to': toMail, 'code': code});
      debugPrint("sended: $code");
      return true;
    } on FirebaseFunctionsException catch (error) {
      debugPrint(error.code);
      debugPrint(error.details);
      debugPrint(error.message);
      return false;
    }
  }

  double getPercentageOfCompletion(ProjectModel projectModel) {
    int taskLength = 0;
    int doneLength = 0;
    for (var task in projectModel.tasks) {
      if (!task.isDeleted) {
        taskLength++;
        if (task.situation == TaskSituation.done) {
          doneLength++;
        }
      }
    }
    return taskLength == 0 ? 0 : (doneLength / taskLength).toDouble();
  }

  Future<void> sendPushMessage(UserModel user, String title, String body) async {
    UserRepository userRepository = UserRepository();
    user = await userRepository.getUserByEmail(user.email);
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAQsHIQXU:APA91bH8WZXi8SGlHe7J9QpZMGIzN2Q_r79VpyS44Tnfe3b3q6KEKiT-Mp6BXSzA8LuVQU_zFQFXdE0iqLN-YXAtbNtzJa_TICcABymcyz1_W8AKSTxJzI3UwnQLpZvUqCsxsqxQK8tf'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'title': title,
              'body': body,
            },
            'notification': <String, dynamic>{
              'android_channel_id': 'taskmallow',
              'title': title,
              'body': body,
            },
            'to': user.notificationToken,
          }));
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error push notification!");
      }
    }
  }

  Future<String> getTranslatedByLocale(String? languageCode, String key) async {
    try {
      late Map<dynamic, dynamic> localizedValues;
      String jsonStringValues = await rootBundle.loadString('lib/localization/languages/${languageCode ?? "en"}.json');
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
      localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
      return localizedValues[key];
    } catch (e) {
      return key;
    }
  }
}
