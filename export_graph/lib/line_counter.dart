import 'dart:io';

String WANTED_EXT = '.dart';
String LINE_COMMENT = '//';
String BLOCK_COMMENT_START = '/*';
String BLOCK_COMMENT_END = '*/';

Future<int> directoryLinesOfCode(String rootDir) async {
  int result = 0;
  Directory dir = Directory(rootDir);
  List<FileSystemEntity> fseList = dir.listSync(recursive: true);
  for (FileSystemEntity fse in fseList) {
    if (fse.path.endsWith(WANTED_EXT) && fse is File)
      result += fileLinesOfCode(fse);
  } // of file loop
  return result;
} // of lines of code

int fileLinesOfCode(File thisFile) {
  String contents = thisFile.readAsStringSync();
  // remove multiline comments
  List<String> tempList = contents.split(BLOCK_COMMENT_START);
  for (int ix = 0; ix < tempList.length; ix++) {
    int terminator = tempList[ix].indexOf(BLOCK_COMMENT_END);
    if (terminator > 0)
      tempList[ix] =
          tempList[ix].substring(terminator + BLOCK_COMMENT_END.length);
  }
  List<String> lines = tempList.join().split('\n');
  // loop backwards so we can delete lines cleanly
  for (int ix = lines.length - 1; ix >= 0; ix--) {
    String thisLine = lines[ix].trim();
    if (thisLine.startsWith(LINE_COMMENT)) lines.removeAt(ix);
  }
  return lines.length;
} // of fileLinesOfCode

void initLanguage({required String language}) {
  switch (language) {
    case 'dart':
      WANTED_EXT = '.dart';
      LINE_COMMENT = '//';
      BLOCK_COMMENT_START = '/*';
      BLOCK_COMMENT_END = '*/';
    case 'python':
      WANTED_EXT = '.py';
      LINE_COMMENT = '#';
      BLOCK_COMMENT_START = 'todo' '''''';
      BLOCK_COMMENT_END = 'todo' '''''';
  }
} // initLanguage
