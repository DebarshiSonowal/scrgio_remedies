import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrgio_remedies/Models/products.dart';
import 'package:sizer/sizer.dart';

import '../../../Constant/constants.dart';
import '../../../Storage/repository.dart';

class ViewScreenScroller extends StatefulWidget {
  const ViewScreenScroller(
      {required this.id,
      required this.update,
      required this.isUp,
      required this.controllerScroll});

  final ScrollController controllerScroll;
  final int id;
  final bool isUp;
  final Function(int,int) update;

  @override
  State<ViewScreenScroller> createState() => _ViewScreenScrollerState();
}

class _ViewScreenScrollerState extends State<ViewScreenScroller>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      bottom: widget.isUp ? 0 : -(50.h),
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 0.2.h,
        ),
        height: 4.h,
        width: double.infinity,
        child: Center(
          child: Consumer<Repository>(builder: (context, data, _) {
            return ListView.separated(
              controller: widget.controllerScroll,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var item = data.products[index];
                return ScrollbarItem(
                  item: item,
                  id: widget.id,
                  update: (int val) {
                    widget.update(item.id!,index);
                  },
                );
              },
              itemCount: data.products.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 2.w,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class ScrollbarItem extends StatelessWidget {
  const ScrollbarItem({
    super.key,
    required this.item,
    required this.id,
    required this.update,
  });

  final Product item;
  final int id;
  final Function(int) update;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 0.5.sp,
      ),
      height: 4.h,
      width: 20.w,
      child: ElevatedButton(
        onPressed: () {
          update(item.id!);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              id != item.id ? Constants.primaryColor : Colors.yellow),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              // side: BorderSide(color: Colors.red)
            ),
          ),
        ),
        child: Text(
          item.product_short_name ?? "",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: id != item.id ? Constants.secondaryColor : Colors.black,
              ),
        ),
      ),
    );
  }
}
