import 'package:flutter/cupertino.dart';

/// This Interface provide a function to display the picture of a model
abstract class IImageModel {
  /// Should return a placeholder Image Widget if the picture attribute is null
  /// Or an Image of the picture attribute otherwise
  ImageProvider getPicture();
}
