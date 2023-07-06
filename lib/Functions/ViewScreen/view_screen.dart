import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:scrgio_remedies/Constant/constants.dart';
import 'package:scrgio_remedies/Functions/ViewScreen/Widgets/view_screen_scroller.dart';
import 'package:scrgio_remedies/Models/products.dart';
import 'package:scrgio_remedies/Storage/repository.dart';
import 'package:sizer/sizer.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key, required this.id});

  final int id;

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  bool isUp = false;
  int? id = 22;
  int index = 0;
  ScrollController controllerScroll = ScrollController();
  PhotoViewControllerBase<PhotoViewControllerValue> controller =
      PhotoViewController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    Future.delayed(Duration.zero, () {
      debugPrint("received ${widget.id}");
      setState(() {
        id = widget.id;
      });

      bringToFront();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Consumer<Repository>(builder: (context, data, _) {
                var current =
                    data.products.firstWhere((element) => element.id == id);
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: zoomed_photo_viewer(controller: controller, current: current),
                );
              }),
            ),
            ViewScreenScroller(
              id: id ?? 0,
              controllerScroll: controllerScroll,
              update: (val,current) {
                setState(() {
                  id = val;
                  index = current;
                });
                if (isUp) {
                  setState(() {
                    isUp = false;
                  });
                } else {
                  setState(() {
                    isUp = true;
                  });
                }
              },
              isUp: isUp,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Consumer<Repository>(builder: (context, data, _) {
                var current =
                    data.products.firstWhere((element) => element.id == id);
                var currentList = data.products;
                return GestureDetector(
                  onTap: () {
                    if (index < data.products.length) {
                      setState(() {
                        id = currentList[++index].id!;
                        controller.scale = 1.0;
                        isUp = false;
                      });
                    }
                  },
                  child: Container(
                    height: 100.h,
                    width: 10.w,
                    color: Colors.transparent,
                  ),
                );
              }),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Consumer<Repository>(builder: (context, data, _) {
                var current =
                    data.products.firstWhere((element) => element.id == id);
                var currentList = data.products;
                return GestureDetector(
                  onTap: () {
                    if (index != 0) {
                      setState(() {
                        id = currentList[--index].id!;
                        controller.scale = 1.0;
                        isUp = false;
                      });
                    }
                  },
                  child: Container(
                    height: 100.h,
                    width: 10.w,
                    color: Colors.transparent,
                  ),
                );
              }),
            ),
            Positioned(
              bottom: isUp ? 4.h : 0,
              child: Consumer<Repository>(builder: (context, data, _) {
                var current =
                    data.products.firstWhere((element) => element.id == id);
                var currentList = data.products;
                return GestureDetector(
                  onTap: () {
                    if (isUp) {
                      setState(() {
                        isUp = false;
                      });
                    } else {
                      setState(() {
                        isUp = true;
                      });
                    }
                  },
                  child: Container(
                    height: 7.h,
                    width: 200.w,
                    color: Colors.transparent,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //   onSwipeUp: (offset) {
  //                       if (!isUp) {
  //                         setState(() {
  //                           isUp = true;
  //                         });
  //                       }
  //                     },
  //                     onSwipeDown: (offset) {
  //                       if (isUp) {
  //                         setState(() {
  //                           isUp = false;
  //                         });
  //                       }
  //                     },
  //                     onSwipeRight: (offset) {
  //                       if (index != 0) {
  //                         setState(() {
  //                           id = currentList[--index].id!;
  //                         });
  //                       }
  //                     },
  //                     onSwipeLeft: (offset) {
  //                       if (index < data.products.length) {
  //                         setState(() {
  //                           id = currentList[++index].id!;
  //                         });
  //                       }
  //                     },
  void bringToFront() {
    List<Product> list =
        Provider.of<Repository>(context, listen: false).products;
    Product current = list.firstWhere((element) => element.id == id);
    list.remove(current);
    list.insert(0, current);
    Provider.of<Repository>(context, listen: false).addProducts(list);
    setState(() {});
  }
}

class zoomed_photo_viewer extends StatelessWidget {
  const zoomed_photo_viewer({
    super.key,
    required this.controller,
    required this.current,
  });

  final PhotoViewControllerBase<PhotoViewControllerValue> controller;
  final Product current;

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      controller: controller,
      wantKeepAlive: true,
      initialScale: 1.0,
      minScale: 1.0,
      maxScale: 10.0,
      backgroundDecoration: const BoxDecoration(
        color: Colors.white,
      ),
      imageProvider: Image.memory(
        base64Decode(current.product_image_64!),
        fit: BoxFit.cover,
      ).image,
    );
  }
}
