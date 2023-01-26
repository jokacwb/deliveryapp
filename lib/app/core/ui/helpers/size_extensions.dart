import 'package:flutter/cupertino.dart';

extension SizeExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double screenWidthPercent(double percent) => MediaQuery.of(this).size.width * (percent / 100.0);
  double screenHeightPercent(double percent) => MediaQuery.of(this).size.height * (percent / 100.0);
}
