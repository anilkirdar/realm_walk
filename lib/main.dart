import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/init/firebase/crashlytics/crashlytics_manager.dart';
import 'core/init/firebase/remote_config/remote_config_manager.dart';
import 'core/init/managers/ad_manager.dart';
import 'core/init/managers/foreground_service_manager.dart';
import 'core/init/print_dev.dart';
import 'core/init/system_init.dart';
// import 'firebase_options.dart';
import 'firebase_options.dart';
import 'myapp.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  AdManager.instance.init();

  /// Note: This sdk is disabled for now
  //FlutterBranchSdk.validateSDKIntegration();

  /// Preserve a splash screen until the first flutter frame is shown
  if (!kIsWeb) FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode
        ? AppleProvider.debug
        : AppleProvider.appAttestWithDeviceCheckFallback,
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  await RemoteConfigManager.instance.initialize();

  /// Initialize firebase messaging
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  /// Initialize system related settings
  await SystemInit.instance.init();

  FlutterError.onError = (details) {
    if (details.library == "image resource service") {
      if (details.exceptionAsString().contains('user-avatars')) {
        return;
      }
      return;
    }
    PrintDev.instance.exception(
      "${details.exceptionAsString()}\n${details.stack?.toString() ?? ''}",
    );
    CrashlyticsManager.instance.sendACrash(
      error: details.exceptionAsString(),
      stackTrace: details.stack ?? StackTrace.current,
      reason: 'FlutterError.onError',
    );
    // if (kReleaseMode) exit(1);
  };

  // Foreground initialize
  ForegroundServiceManager.instance.initForegroundService();

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage message) async {
  PrintDev.instance.debug('background message ${message.toMap()}');
}

// List events = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchEvents();
//   }

//   Future<void> fetchEvents() async {
//     final response = await http.get(Uri.parse('http://localhost:5000/events'));
//     if (response.statusCode == 200) {
//       setState(() {
//         events = json.decode(response.body);
//         events.add({
//           'title': 'Event 1',
//           'description': 'Event 1 Description',
//           'imageUrl': 'https://placehold.co/600x400.png',
//         });
//         events.add({
//           'title': 'Event 2',
//           'description': 'Event 2 Description',
//           'imageUrl': 'https://placehold.co/600x400.png',
//         });
//         events.add({
//           'title': 'Event 3',
//           'description': 'Event 3 Description',
//           'imageUrl': 'https://placehold.co/600x400.png',
//         });
//         events.add({
//           'title': 'Event 4',
//           'description': 'Event 4 Description',
//           'imageUrl': 'https://placehold.co/600x400.png',
//         });
//       });
//     }
//   }

//   void navigateToReservation(Map event) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ReservationScreen(event: event)),
//     );
//   }

// class ReservationScreen extends StatefulWidget {
//   final Map event;
//   ReservationScreen({super.key, required this.event});

//   @override
//   _ReservationScreenState createState() => _ReservationScreenState();
// }

// class _ReservationScreenState extends State<ReservationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String name = '', email = '', phone = '';

//   Future<void> makeReservation() async {
//     final response = await http.post(
//       Uri.parse('http://localhost:5000/reserve'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'name': name,
//         'email': email,
//         'phone': phone,
//         'eventId': widget.event['_id'],
//       }),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Rezervasyon başarılı!')));
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Rezervasyon başarısız!')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('${widget.event['title']} - Rezervasyon')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Ad Soyad'),
//                 onChanged: (value) => name = value,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'E-Posta'),
//                 onChanged: (value) => email = value,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Telefon'),
//                 onChanged: (value) => phone = value,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: makeReservation,
//                 child: Text('Ödeme Yap ve Rezervasyon Tamamla'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
