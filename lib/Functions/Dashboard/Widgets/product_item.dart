import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:scrgio_remedies/Constant/assets.dart';
import 'package:scrgio_remedies/Constant/routes.dart';
import 'package:scrgio_remedies/Models/products.dart';
import 'package:scrgio_remedies/Navigation/navigator.dart';
import 'package:sizer/sizer.dart';

import '../../../Constant/constants.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.num, required this.product,
  });

  final Product product;
  final int num;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.3.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Constants.secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        child: InkWell(
          onTap: () {
            Navigation.instance.navigate(
              Routes.viewScreen,
              args: product.id,
            );
          },
          splashColor: Constants.primaryColor,
          child: Ink(
            color: Constants.secondaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15.w,
                  child: IgnorePointer(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Constants.primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            // side: BorderSide(color: Colors.red)
                          ),
                        ),
                      ),
                      child: Text(
                        product.product_short_name??"",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Constants.secondaryColor,
                            ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                SizedBox(
                  width: 35.w,
                  child: Text(
                   product.product_name??"",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
