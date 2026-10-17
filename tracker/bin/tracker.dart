import 'package:tracker/tracker.dart' as tracker;
import 'package:cli_help/cli_help.dart';

void main(List<String> arguments) {
  CliHelp.check(arguments);
  print('Hello world: ${tracker.calculate()}!');
}
