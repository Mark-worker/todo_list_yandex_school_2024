import "package:flutter/foundation.dart";
import "package:logger/logger.dart";

// final logger = Logger(
//   level: kDebugMode ? Level.all : Level.off,
//   printer: SimplePrinter(
//     colors: true,
//   ),
// );

final logger = Logger();

class SimpleLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.defaultLevelColors[event.level];
    var emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    var stack = event.stackTrace?.toString().split("\n")[0];
    return [
      (color!(
          "${emoji ?? ""} - ${stack ?? ""} - ${event.message ?? "something went wrong"}"))
    ];
  }
}
