import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dalllalalarab/constants.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  ImagePreview({this.images});
  final List<String> images;
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  double height;
  double width;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
    } else {
      height = MediaQuery.of(context).size.width;
      width = MediaQuery.of(context).size.height;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("تفاصيل الصور"),
      ),
      body: Container(
        decoration: (BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bc.jpg'), fit: BoxFit.cover),
        )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: mycolor, width: 3),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.white,
              ),
              child: Carousel(
                autoplay: true,
                animationCurve: Curves.easeOut,
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Colors.lightGreenAccent,
                indicatorBgPadding: 5.0,
                dotBgColor: mycolor.withOpacity(0.5),
                borderRadius: true,
                moveIndicatorFromBottom: 180.0,
                noRadiusForIndicator: true,
                overlayShadow: true,
                overlayShadowColors: Colors.white,
                overlayShadowSize: 0.7,
                images: widget.images
                    .map((item) => Container(
                          child: CachedNetworkImage(
                            fadeInCurve: Curves.easeInBack,
                            fit: BoxFit.cover,
                            width: width,
                            height: height * 0.2,
                            imageUrl: item,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image.asset(
                              'images/bc.jpg',
                              height: height * 0.2,
                              width: width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
