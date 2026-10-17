// load CSV  project

String DELIMITER = ',';

class Project {
  String name = 'no project name';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<Task> tasks = [];

  Project.loadFromCSV(List<String> lines) {
    tasks = []; // clean up before loading
    String thisLine = '';
    int lineIx = 0;
    try {
      for (int lineIx = 0; lineIx < lines.length; lineIx++) {
        thisLine = lines[lineIx].trim();
        if (thisLine.isEmpty) continue; // skip empty lines

        if (thisLine.startsWith('@')) {
          processCsvCommand(thisLine.split(DELIMITER));
        } else {
          tasks.add(Task.fromLine(thisLine.split(DELIMITER)));
        }
      } // lineIx loop
    } catch (ex) {
      throw Exception(
          'Failed on task line ${lineIx + 1} with error $ex \n The line was ($thisLine)');
    }
  } // of loadFromCSV

  Map<String, Object> get asMap {
    Map<String, Object> result = {
      'startDate': startDate,
      'endDate': endDate,
      'tasks': []
    };
    for (var task in tasks) result['tasks']!.add(task.asMap);
    return result;
  }

  processCsvCommand(List<String> columns) {
    switch (columns[0]) {
      case '@start':
        startDate = DateTime.parse(columns[1]);
      case '@end':
        endDate = DateTime.parse(columns[1]);
      default:
        throw ('Invalid command ${columns[0]}');
    }
  } // of processCommand

  /// return outstanding units, total units
  (double, int) get sofar {
    double osUnits = 0;
    int sizeInUnits = 0;
    for (var task in tasks) {
      osUnits += task.outstandingInUnits;
      sizeInUnits += task.sizeInUnits;
    }
    return (osUnits, sizeInUnits);
  } // of sofar
} // of project

class Task {
  String number = '';
  String description = '';
  String size = 'M'; // big=9,medium=3,small=1
  String progress = 'U';
  // unstarted=0,inprogress=10,designing=25,
  // programming=50,testing=75,finished=100
  String group = 'None';
  DateTime? finishedOn;

  Task.fromLine(List<String> thisLine) {
    if (thisLine.length < 4)
      throw Exception('We need at least five tokens in ($thisLine)');
    for (int i = 0; i < thisLine.length; i++) thisLine[i] = thisLine[i].trim();

    number = thisLine[0];
    description = thisLine[1];
    size = thisLine[2].toUpperCase();
    progress = thisLine[3].toUpperCase();
    if (thisLine.length > 4) group = thisLine[4];
    if (thisLine.length > 5) finishedOn = DateTime.parse(thisLine[5]);
  } // of constructor from Line

  Map<String, Object> get asMap {
    Map<String, Object> result = {
      'number': number,
      'description': description,
      'size': size,
      'progress': progress,
      'finishedDate': (finishedOn?.toIso8601String() ?? ''),
      'outstanding': outstandingInUnits,
      'sizeInUnits': sizeInUnits
    };

    return result;
  }

  bool get isDone => finishedOn != null;

  double get outstandingInUnits {
    return sizeInUnits * (1 - 0.01 * progressInPercent);
  } // of outstandingInUnits

  int get progressInPercent {
    // unstarted,inprogress,designing,programming,testing,finished
    if (finishedOn != null) return 100; // has a finshedOnDate
    if (progress == 'I') return 10;
    if (progress == 'D') return 20;
    if (progress == 'P') return 50;
    if (progress == 'T') return 80;
    if (progress == 'F') return 100;
    return 0;
  } // progressInUnits

  int get sizeInUnits {
    if (number == '') return 0;
    if (size == 'L') return 9;
    if (size == 'M') return 3;
    if (size == 'S') return 1;
    throw Exception('Invalid task size for $number - $description');
  } // of sizeInUnits

  /// return outstanding units, total units
  (double, int) get sofar => (outstandingInUnits, sizeInUnits);
} // of Task

