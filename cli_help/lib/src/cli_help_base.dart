// Put public facing types in this file.
import 'dart:io';

const helpFileName = 'helpText.txt';

class CliHelp {
  static final List<String> options = ['-h', '--help', '?'];

  static check(List<String> args) {
    bool needsHelp = false;
    String helpKey = ''; // used to look up help
    for (String arg in args) {
      if (options.contains(arg.toLowerCase()))
        needsHelp = true;
      else
        helpKey += arg.toLowerCase();
    }
    // exit if we don't need command line help
    if (!needsHelp) return '';

    // now load the help text
    Map<String, String> helpText = loadFile('help.txt');
    print('Help for "$helpKey"');
    if (!helpText.containsKey(helpKey)) helpKey = 'default';
    print(helpText[helpKey]);
    exit(4); // abort with commandline help
  } // of check

  static Map<String, String> loadFile(String filename) {
    String rootPath = '.';
    String helpFilePath = '$rootPath/$helpFileName';
    if (!File(helpFilePath).existsSync()) {
      stderr.writeln('Missing help text file $helpFilePath');
      exit(16);
    }
    List<String> lines = File(helpFilePath).readAsLinesSync();
    String helpKey = 'default';
    Map<String, String> result = {'default': 'No help text in helptext.txt'};
    for (String line in lines) {
      if (line.startsWith('+')) {
        // initialise help topic
        helpKey = line.substring(1).trim().toLowerCase();
        result[helpKey] = '';
      } else {
        // add to current helpTopic
        result[helpKey] = [result[helpKey], line].join('\n');
      }
    } // of line loop
    return result;
  } // of loadFile
}
