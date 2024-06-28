import "package:flutter/foundation.dart";
import "package:logger/logger.dart";

final logger = Logger(
  level: kDebugMode ? Level.all : Level.off,
  printer: SimplePrinter(
    colors: true,
  ),
);
