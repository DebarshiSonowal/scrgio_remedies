import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:scrgio_remedies/Constant/assets.dart';
import 'package:scrgio_remedies/Constant/constants.dart';
import 'package:scrgio_remedies/Constant/routes.dart';
import 'package:scrgio_remedies/Navigation/navigator.dart';
import 'package:scrgio_remedies/Storage/repository.dart';
import 'package:sizer/sizer.dart';
import '../../Api/api_provider.dart';
import '../../Storage/local_storage.dart';
import 'Widgets/product_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? versionCode;

  @override
  void initState() {
    super.initState;
    fetchVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        // leading: Container(
        //   width: 20.w,
        //   margin: EdgeInsets.only(
        //     left: 2.w,
        //   ),
        //   child: Text(
        //     "Version: ${versionCode ?? ""}",
        //     style: Theme.of(context).textTheme.labelSmall?.copyWith(
        //       color: Constants.secondaryColor,
        //     ),
        //   ),
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 20.w,
              margin: EdgeInsets.only(
                left: 2.w,
              ),
              child: Text(
                "Version: ${versionCode ?? ""}",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Constants.secondaryColor,
                ),
              ),
            ),
            Image.asset(
              Assets.logo,
              color: Colors.white,
              // scale:5,
              fit: BoxFit.fitWidth,
              width: 35.w,
            ),
            Container(
              width: 20.w,
              margin: EdgeInsets.only(
                left: 2.w,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await fetchProducts();
              await fetchVersion();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () async {
              await Storage.instance.clean();
              Navigation.instance.navigateAndRemoveUntil(Routes.loginScreen);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.h,
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Products",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Constants.primaryColor,
                  ),
            ),
            Expanded(
              child: Consumer<Repository>(builder: (context, data, _) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            // maxCrossAxisExtent: 200,
                            crossAxisCount: 2,
                            childAspectRatio: 10 / 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 100),
                    itemCount: data.products.length,
                    itemBuilder: (BuildContext ctx, index) {
                      int num = Random().nextInt(3);
                      var item = data.products[index];
                      return ProductItem(
                        num: num,
                        product: item,
                      );
                    });
              }),
            ),
          ],
        ),
      ),
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

  Future<void> fetchVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionCode = packageInfo.version;
    });
  }
}
