library speedpad_service.storage_service;

import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_classes/shared_classes.dart';
import 'package:speedpad_service/file_helper.dart';
import 'package:logging/logging.dart';
import 'package:speedpad_service/logging_identifiers.dart';

class StorageService {
  ///Filename of link structure file
  static String LINK_STRUCTURE_FILENAME = "structure.json";

  final Logger _logger = new Logger("$SpeedpadServiceID.StorageService");

  FileHelper fileHelper;

  ///private constructor
  StorageService._privateConstructor(FileHelper this.fileHelper);

  ///official factory constructor
  static Future<StorageService> createStorageService() async {
    var fileHelper = await FileHelper.createFileHelper();
    return new StorageService._privateConstructor(fileHelper);
  }

  ///helper function getting the link structure as string from the structure file
  Future<String> getLinkStructure() async {
    //Loading link structure file
    try {
      return await fileHelper.loadFile(LINK_STRUCTURE_FILENAME);
    } on String catch (error) {
      _logger.shout(error);
      _logger.finest(error.runtimeType);
      if (error == "FileNotFound") {
        //Fill structure file with basic main tab
        List<TabEntry> structure = [];
        structure.add(new TabEntry("Home"));
        //Create file on syncFileSystem
        var _ = await fileHelper.createFileOnSyncFS(LINK_STRUCTURE_FILENAME, defaultContent: serializeToJson(structure));
        return await fileHelper.loadFile(LINK_STRUCTURE_FILENAME);
      }
    }
  }

  ///gets the hash of the tab name to identify which tab to load
  ///this hash will be received from the client
  Future<String> getLinksInTab(String tabId) async {
    _logger.finest("getLinksInTab: $tabId");
    return fileHelper.loadFile(tabId);
  }

  saveLinksInTab(String tabId, String content) {
    _logger.finest("saveLinksInTab: $tabId");
    fileHelper.updateFile(tabId, content);
  }
}
