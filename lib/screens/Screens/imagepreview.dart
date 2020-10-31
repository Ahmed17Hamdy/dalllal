import 'package:cached_network_image/cached_network_image.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ListView.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index) => Container(
                height: height * .4,
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                child: CachedNetworkImage(
                  fadeInCurve: Curves.easeInBack,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: height * 0.2,
                  imageUrl: widget.images[index],
                  placeholder: (context, url) => Center(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'images/bc.jpg',
                    height: height * 0.2,
                    width: width,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
