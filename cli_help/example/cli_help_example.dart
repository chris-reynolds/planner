import 'package:cli_help/cli_help.dart';

void main(List<String> args) {
  CliHelp.check(args);
  // normal code is run if help is not invoked on the commandline
  print('awesome: app stuff');
}
