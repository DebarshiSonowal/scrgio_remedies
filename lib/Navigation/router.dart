import 'package:flutter/material.dart';
import 'package:scrgio_remedies/Functions/LogIn/login_screen.dart';

import '../Constant/routes.dart';
import '../Functions/Dashboard/dashboard_screen.dart';
import '../Functions/SplashScreen/splash_screen.dart';
import '../Functions/ViewScreen/view_screen.dart';
import '../Widgets/fade_transition.dart';
import '../Widgets/loading_dialog.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.splashScreen:
      return FadeTransitionPageRouteBuilder(
        page: const SplashScreen(),
      );

    //login
    case Routes.loginScreen:
      return FadeTransitionPageRouteBuilder(
        page: const LogInScreen(),
      );
    case Routes.dashboardScreen:
      return FadeTransitionPageRouteBuilder(
        page: const DashboardScreen(),
      );
    case Routes.viewScreen:
      return FadeTransitionPageRouteBuilder(
        page: ViewScreen(
          id: settings.arguments as int,
        ),
      );
    case Routes.loadingDialog:
      return FadeTransitionPageRouteBuilder(
        page: LoadingDialog(),
      );

    default:
      return FadeTransitionPageRouteBuilder(
        page: Container(),
      );
  }
}
