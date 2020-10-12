import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

File jsonFile;
Directory dir;

bool fileExists = false;
Map<String, dynamic> fileContent;

class LocalStorage {
  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    // print(file);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
    print(json.decode(jsonFile.readAsStringSync()));
  }

  void writeToFile(String key, dynamic value, Directory dir, File jsonFile,
      String fileName) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    // this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    //print(fileContent);
  }

  void deleteFile(File filename) {
    filename.deleteSync();
    print('file deleted');
  }
}
