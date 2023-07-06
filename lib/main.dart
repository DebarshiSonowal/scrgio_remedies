import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:scrgio_remedies/Storage/local_storage.dart';
import 'package:sizer/sizer.dart';

import 'Navigation/navigator.dart';
import 'Navigation/router.dart';

// import 'Repository/repository.dart';
import 'Storage/repository.dart';
import 'Theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.instance.initializeStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Repository(),
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Scrgio Remedies',
          theme: AppTheme.getTheme(),
          navigatorKey: Navigation.instance.navigatorKey,
          onGenerateRoute: generateRoute,
          builder: EasyLoading.init(),
        );
      }),
    );
  }
}
