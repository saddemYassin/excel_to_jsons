import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:args/args.dart';

const String defaultFilePath = 'to_translate.xlsx';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addOption(
      'inputFilePath',
      abbr: 'i',
      help: 'Show additional command output.',
    )
    ..addOption(
      'outDir',
      abbr: 'o',
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart excel_to_jsons.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    // Define the path to your Excel file
    var inputFilePath = defaultFilePath;
    var outputDirPath = '';
    Directory? outDir;

    if(results.wasParsed('inputFilePath')) {
      inputFilePath = results.option('inputFilePath') ?? defaultFilePath;
    }

    if(results.wasParsed('outDir')) {
      outputDirPath = results.option('outDir') ?? '';
      if(outputDirPath.trim().isNotEmpty){
        outDir = Directory(outputDirPath);
        if(!await outDir.exists()){
          await outDir.create(recursive: true);
        }
      }
    }




    // Read the Excel file
    var bytes = File(inputFilePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    // Check if we have sheets
    if (excel.tables.isEmpty) {
      print('No sheets found in the Excel file.');
      return;
    }

    // Get the first sheet
    var sheet = excel.tables.values.first;

    // Check if there are rows
    if (sheet.rows.isEmpty) {
      print('No rows found in the sheet.');
      return;
    }

    // Extract the header row (language codes)
    var headers = sheet.rows.first;
    if (headers.isEmpty) {
      print('Header row is empty.');
      return;
    }

    // Process each language (excluding the first column which contains keys)
    for (var i = 1; i < headers.length; i++) {
      var languageCode = headers[i]?.value.toString();
      var translations = <String, String>{};

      // Process each row (excluding the header row)
      for (var row in sheet.rows.skip(1)) {
        if (row.length > i) {
          var key = row[0]?.value.toString();
          var value = row[i]?.value.toString();

          if (key != null && value != null) {
            translations[key] = value;
          }
        }
      }

      // Write the translations to a JSON file
      var jsonFilePath = "${outputDirPath.trim().isNotEmpty ? outputDirPath.trim() + '/' : ''}${languageCode?.trim()}_${languageCode?.trim()
          .toUpperCase()}.json";
      var jsonFile = File(jsonFilePath);
      await jsonFile.create();
      await jsonFile.writeAsString(
          getPrettyJSONString(translations), mode: FileMode.write);

      print('Translations for language "$languageCode" saved to $jsonFilePath');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    printUsage(argParser);
  }
}

String getPrettyJSONString(jsonObject){
  var encoder = JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}