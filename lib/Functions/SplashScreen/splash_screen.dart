import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:scrgio_remedies/Api/api_provider.dart';
import 'package:scrgio_remedies/Constant/assets.dart';
import 'package:scrgio_remedies/Constant/routes.dart';
import 'package:scrgio_remedies/Navigation/navigator.dart';
import 'package:scrgio_remedies/Storage/local_storage.dart';
import 'package:scrgio_remedies/Storage/repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          Assets.splash,
          // scale: 2,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(
        seconds: 1,
      ),
      () async {
        if (Storage.instance.isLoggedIn) {
          await fetchProducts();
          Future.delayed(const Duration(seconds: 2), () {
            Navigation.instance.navigateAndRemoveUntil(Routes.dashboardScreen);
          });

        } else {
          Future.delayed(const Duration(seconds: 2), () {
            Navigation.instance.navigateAndRemoveUntil(Routes.loginScreen);
          });
        }
      },
    );
  }

  Future<void> fetchProducts() async {
    final result = await InternetConnectionChecker().hasConnection;
    if (result) {
      final response = await ApiProvider.instance.products();
      if (response.error ?? true) {
      } else {
        String token = await Storage.instance.token;
        await Storage.instance.clean();
        await Storage.instance.setToken(token);
        await Storage.instance.setProductList(response.products);
        Provider.of<Repository>(context, listen: false)
            .addProducts(response.products);
      }
    } else {
      final list =
      await Storage.instance.getListFromProductsRoutineSharedPreferences();
      Provider.of<Repository>(context, listen: false).addProducts(list);
    }
  }
}
