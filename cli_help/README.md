# cli_help

## Description

This allows a developer to create a Dart command line application that supports
help in the console like:

```
    MyOwnApp myCommand --help
```

## Features

This package supports help in the console without mixing the help text with your code for validation or functionality.

The help facility can be triggered by -h --help or a question mark as a token on the command line.

## Getting started

Add a dependency in pubspec.yaml to cli_help

```
dependencies:
  # path: ^1.8.0
  cli_help:
    path: c:/users/chris/projects/planner/cli_help
```

## Usage

In the main application entry point, do a call to CliHelp.check and pass in the command line parameters as below.
 

```dart
import 'package:cli_help/cli_help.dart';

void main(List<String> arguments) {
  CliHelp.check(arguments);
  ... your normal application code here.
}
```

## Additional information

All the help is contained in a simple text file called helptext.txt in the root folder of the project.


The helptext.txt file is in the format below with each topic starting with a plus sign in column 1:


```
+default
A command-line utility for yourapp.

Usage: yourapp <command> [arguments]

Available commands:
  doc        Generate API documentation for yourapp.
  doc verx   Generate vertical documentation for yourapp.
  format     Format stuff.
  test       Run tests for a project.

+doc
Some stuff here to describe what arguments the doc command takes.

+docverb
Some stuff here to describe what arguments the doc verx command takes.



```

Note that the help topic names start with a plus sign.

If a help topic is not found, then the default topic is shown.


```
    yourapp silliness --help 
```
will trigger the display of the *default* help topic.




<!--
Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
-->
