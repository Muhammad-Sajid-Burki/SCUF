import 'package:flutter/material.dart';

import '../../../widgets/colors.dart';

class ProductPoster extends StatelessWidget {
  const ProductPoster({
    Key? key,
    @required this.size,
    this.image,
  }) : super(key: key);

  final Size? size;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      // the height of this container is 80% of our width
      height: size!.width * 0.8,

      child: Container(
        height: size!.width * 0.9,
        width: size!.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),

      child: Image.network(
        image!,

        fit: BoxFit.fill,
      ),
      ),
    );
  }
}
