library folder_entry;

import 'package:shared_classes/src/data_classes/speedpad_entry.dart';
import 'package:shared_classes/src/serialization/serializable.dart';

class FolderEntry extends SpeedpadEntry implements Serializable {
  FolderEntry() : super(SpeedpadEntryType.Folder) {}

  FolderEntry.fromMap(Map json) : super.fromMap(json) {}

  Map toMap() {
    var map = new Map();
    map.addAll(super.toMap());
    return map;
  }
}
