import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:taskmallow/pages/authentication_pages/change_password_page.dart';
import 'package:taskmallow/pages/authentication_pages/forgot_password_page.dart';
import 'package:taskmallow/pages/authentication_pages/register_page.dart';
import 'package:taskmallow/pages/authentication_pages/verification_code_page.dart';
import 'package:taskmallow/pages/create_project_page.dart';
import 'package:taskmallow/pages/create_task_page.dart';
import 'package:taskmallow/pages/edit_profile_page.dart';
import 'package:taskmallow/pages/home_page.dart';
import 'package:taskmallow/pages/authentication_pages/login_page.dart';
import 'package:taskmallow/pages/project_detail_page.dart';
import 'package:taskmallow/pages/settings_pages/settings_page.dart';
import 'package:taskmallow/pages/update_project_page.dart';
import 'package:taskmallow/pages/update_task_page.dart';
import 'package:taskmallow/routes/route_constants.dart';

class RouteGenerator {
  static Route<dynamic> createRoute(Widget routeToGo, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // return MaterialPageRoute(builder: (_) => _RouteToGo, settings: settings); //android

      // return PageRouteBuilder(
      //   settings: settings,
      //   pageBuilder: (c, a1, a2) => routeToGo,
      //   transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      //   transitionDuration: const Duration(milliseconds: 100),
      //   reverseTransitionDuration: const Duration(milliseconds: 100),
      // );

      // return PageRouteBuilder(
      //   pageBuilder: (context, animation, secondaryAnimation) => _RouteToGo,
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     const begin = Offset(0.0, 1.0);
      //     const end = Offset.zero;
      //     const curve = Curves.ease;

      //     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      //     return SlideTransition(
      //       position: animation.drive(tween),
      //       child: child,
      //     );
      //   },
      // );

      return CupertinoPageRoute(builder: (_) => routeToGo, settings: settings); //ios
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(builder: (_) => routeToGo, settings: settings); //ios
    } else {
      return CupertinoPageRoute(builder: (_) => routeToGo, settings: settings); //web
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPageRoute:
        return createRoute(const LoginPage(), settings);
      case registerPageRoute:
        return createRoute(const RegisterPage(), settings);
      case forgotPasswordPageRoute:
        return createRoute(const ForgotPasswordPage(), settings);
      case changePasswordPageRoute:
        return createRoute(const ChangePasswordPage(), settings);
      case verificationCodePageRoute:
        return createRoute(const VerificationCodePage(), settings);
      case homePageRoute:
        return createRoute(const HomePage(), settings);
      case editProfilePageRoute:
        return createRoute(const EditProfilePage(), settings);
      case createProjectPageRoute:
        return createRoute(const CreateProjectPage(), settings);
      case updateProjectPageRoute:
        return createRoute(const UpdateProjectPage(), settings);
      case createTaskPageRoute:
        return createRoute(const CreateTaskPage(), settings);
      case updateTaskPageRoute:
        return createRoute(const UpdateTaskPage(), settings);
      case settingsPageRoute:
        return createRoute(const SettingsPage(), settings);
      case projectDetailPageRoute:
        return createRoute(const ProjectDetailPage(), settings);
      default:
        return createRoute(const LoginPage(), settings);
    }
  }
}
