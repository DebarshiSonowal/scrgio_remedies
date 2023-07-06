import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:scrgio_remedies/Api/api_provider.dart';
import 'package:scrgio_remedies/Constant/constants.dart';
import 'package:scrgio_remedies/Constant/routes.dart';
import 'package:scrgio_remedies/Helper/validator.dart';
import 'package:scrgio_remedies/Navigation/navigator.dart';
import 'package:sizer/sizer.dart';
import '../../Storage/local_storage.dart';
import '../../Constant/assets.dart';
import '../../Storage/repository.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isEnabled = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.logo,
              scale: 3,
            ),
            SizedBox(
              width: 60.w,
              child: TextFormField(
                controller: emailController,
                validator: (val) {
                  return (val!.isValidEmail) ? null : "Email is Not Valid";
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                    ),
                  ),
                  labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.black87,
                      ),
                ),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              width: 60.w,
              child: TextFormField(
                controller: passwordController,
                validator: (val) {
                  return (val!.isValidEmail) ? null : "Email is Not Valid";
                },
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: isEnabled,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isEnabled = !isEnabled;
                      });
                    },
                    child: Icon(
                      isEnabled ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                  ),
                  labelText: "Enter Password",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                    ),
                  ),
                  labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.black87,
                      ),
                ),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            SizedBox(
              width: 30.w,
              height: 3.h,
              child: ElevatedButton(
                onPressed: () {
                  login(emailController.text, passwordController.text,context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constants.primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: BorderSide(color: Colors.red)
                    ),
                  ),
                ),
                child: Text(
                  "Log In",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login(email, password,context) async {
    Navigation.instance.navigate(Routes.loadingDialog);
    final response = await ApiProvider.instance.login(
      email,
      password,
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
    );
    if (response.error ?? true) {
      Navigation.instance.goBack();
      CherryToast.error(
              title: Text(
                "Oops! Login Failed",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
              ),
              displayTitle: true,
              description: Text(
                response.message ?? "Something went wrong",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black45,
                      fontSize: 10.sp,
                    ),
              ),
              animationType: AnimationType.fromTop,
              animationDuration: const Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
    } else {
      CherryToast.success(
          title: Text(
            "Logged In Successfully",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
          ),
          displayTitle: true,
          description: Text(
            response.message ?? "Successfully ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black45,
                  fontSize: 10.sp,
                ),
          ),
          animationType: AnimationType.fromTop,
          animationDuration: const Duration(milliseconds: 1000),
          autoDismiss: true);
      await Storage.instance.setToken(response.token ?? "");
      await fetchProducts();
      Navigation.instance.navigateAndRemoveUntil(Routes.dashboardScreen);
    }
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
