# Excel to JSON Translation Script

A Dart script to automate the process of converting translations from an Excel file into JSON files, categorized by language.

## Features

- Parses an Excel file containing translation keys and their corresponding translations in multiple languages.
- Converts the translations into individual JSON files for each language.
- Allows specifying the input Excel file and output directory via command-line arguments.

## Prerequisites

- Dart SDK installed. You can download it from the official [Dart website](https://dart.dev/get-dart).
- Install the required Dart packages using [pub.dev](https://pub.dev).

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/saddemYassin/excel_to_jsons/tree/main
   cd excel-to-jsons-dart-script
   ```
2. Install the required dependencies:
   ```bash
   dart pub get
   ```
## Usage

You can run the script in two ways:

1.  **Basic usage**: By default, the script reads from `to_translate.xlsx` in the current directory and outputs the JSON files in the same directory.
    ```bash
     dart bin/excel_to_jsons.dart`
     ```
2. **Custom input and output paths**: Use the `-i` flag to specify the input Excel file path and `-o` to specify the output directory for the JSON files.
   Example:
   ```bash
   dart bin/excel_to_jsons.dart -i path/to/your/input.xlsx -o path/to/output/directory
   ```
## Command-Line Options

| Option                | Description                                        |
|-----------------------|----------------------------------------------------|
| `-h`, `--help`        | Display help and usage information.                |
| `-i`, `--inputFilePath` | Specify the path to the input Excel file.         |
| `-o`, `--outDir`      | Specify the directory to save the JSON files.      |

## Example Excel File

The first row of the Excel file should contain language codes, and the first column should have the keys for the translations. The following is an example format:

| Key       | en      | fr         | es    |
|-----------|---------|------------|-------|
| hello     | Hello   | Bonjour    | Hola  |
| goodbye   | Goodbye | Au revoir  | Adiós |

## Output

For the above example, the script will generate JSON files for each language, such as:

- `en_EN.json`
- `fr_FR.json`
- `es_ES.json`

Each JSON file will contain the key-value pairs for that language. For instance, `en_EN.json` will look like:

```json
{
  "hello": "Hello",
  "goodbye": "Goodbye"
}
