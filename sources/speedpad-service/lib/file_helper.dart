library file_helper;

import 'dart:async';
import 'dart:html';
import 'package:chrome/chrome_app.dart' as chrome;
import 'tools.dart';
import 'package:logging/logging.dart';
import 'package:speedpad_service/logging_identifiers.dart';

class FileHelper {
  chrome.FileSystem fileSystem;
  bool useLocalStorage = false;
  static Logger _logger = new Logger("$SpeedpadServiceID.FileHelper");

  FileHelper._privateConstructor({chrome.FileSystem this.fileSystem}) {
    if (fileSystem == null) {
      _logger.info("No SyncFileSystem acquired - using chrome.storage.local");
      useLocalStorage = true;
    } else {
      _logger.info("using SyncFileSystem");
    }
  }

  static Future<FileHelper> createFileHelper() async {
    try {
      var fs = await acquireFileSystem();
      return new FileHelper._privateConstructor(fileSystem: fs);
    } catch (error) {
      if (error == -107) {
        return new FileHelper._privateConstructor();
      }
      throw new Exception("Unknown Error in file system acquision");
    }
  }

  ///gets the sync file system object
  ///
  static Future acquireFileSystem() async {
    var fileSystem;
    try {
      fileSystem = chrome.syncFileSystem.requestFileSystem();
      if (fileSystem != null) {
        _logger.info("SyncFileSystem acquired");
      }
    } catch (error) {
      var errorNumber = extractErrorCodeFromMessage(error);
      if (errorNumber == -107) {
        _logger.info("Not authorized in Chrome. No SyncFileSystem acquired");
        throw -107;
      }
      rethrow;
    }

    return fileSystem;
  }

  String loadLinksFromLocalStorage() {
    throw new UnimplementedError("This function is not implemented right now");
  }

  ///Opens the given file and returns a String with the file content
  ///The content will be a json string for my own files
  Future<String> loadFileFromFS(String filename) {
    _logger.finer("loadFileFromFs: $filename");
    var completer = new Completer<String>();

    assert(fileSystem != null);

    Future<chrome.FileEntry> entry = fileSystem.root.getFile(filename);

    entry.then((chrome.FileEntry e) {
      e.file().then((chrome.File file) {
        var reader = new chrome.FileReader();
        reader.onLoadEnd.listen((ProgressEvent event) {
          //complete with json String
          completer.complete(reader.result);
        });

        reader.onError.listen((error) => _logger.shout("Error on file reading: $error"));
        reader.readAsText(file, "UTF8");
      });
    }).catchError((FileError error) {
      if (error.name == "NotFoundError") {
        completer.completeError("FileNotFound");
      } else {
        completer.completeError(error.name);
      }
    });

    return completer.future;
  }

  ///Writes a given json string to the given file
  Future updateFile(String filename, String jsonContent) async {
    if (await fileExists(filename)) {
      chrome.ChromeFileEntry entry = await fileSystem.root.getFile(filename);
      var result = await entry.writeText("$jsonContent\n");
      _logger.finer("Updated file $filename: $result");
      return result;
    } else {
      createFileOnSyncFS(filename, defaultContent: "$jsonContent\n");
    }
  }

  ///Creates a file on the sync file system and inserts optional given content
  ///defaultContent is in json format
  Future<chrome.ChromeFileEntry> createFileOnSyncFS(String filename, {String defaultContent}) async {
    chrome.ChromeFileEntry file;
    if (!(await fileExists(filename))) {
      _logger.info("File $filename does not exist - creating");
      file = await fileSystem.root.createFile(filename);
      if (defaultContent != null) {
        updateFile(filename, defaultContent);
      }
    } else {
      file = await fileSystem.root.getFile(filename);
    }

    return file;
  }

  ///returns the content of the file as string
  Future<String> loadFile(String filename) async {
    var result;
    if (useLocalStorage) {
      result = loadLinksFromLocalStorage();
    } else {
      result = loadFileFromFS(filename);
    }

    return result;
  }

  ///checks if file exists in syncFS
  Future<bool> fileExists(String filename) async {
    chrome.FileEntry file;
    try {
      file = await fileSystem.root.getFile(filename);
    } on FileError catch (error) {
      if (error.name == "NotFoundError") {
        return false;
      }
    }

    if (file.name.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
