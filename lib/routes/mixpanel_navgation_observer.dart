// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../core/init/managers/analytic_manager.dart';

// class MixpanelNavigationObserver extends NavigatorObserver {
//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPush(route, previousRoute);

//     final String? currentRoute = route.settings.name;
//     final String? previousRouteName = previousRoute?.settings.name;

//     if (currentRoute != null) {
//       AnalyticManager.instance.tagScreen(currentRoute, previousRouteName);
//       AnalyticsManager.instance.logScreenView(currentRoute);
//     }
//   }

//   @override
//   void didReplace({Route? newRoute, Route? oldRoute}) {
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

//     final String? currentRoute = newRoute?.settings.name;
//     final String? previousRouteName = oldRoute?.settings.name;

//     if (currentRoute != null) {
//       AnalyticManager.instance.tagScreen(currentRoute, previousRouteName);
//       AnalyticsManager.instance.logScreenView(currentRoute);
//     }
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPop(route, previousRoute);

//     final String? currentRoute = previousRoute?.settings.name;
//     final String? poppedRouteName = route.settings.name;

//     if (currentRoute != null) {
//       AnalyticManager.instance.tagScreen(currentRoute, poppedRouteName);
//       AnalyticsManager.instance.logScreenView(currentRoute);
//     }
//   }
// }
