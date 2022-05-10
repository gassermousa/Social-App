import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  final String? image;

  const ImageViewScreen({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(
          '$image',
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
