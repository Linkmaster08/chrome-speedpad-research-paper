library link_entry;

import 'package:shared_classes/src/data_classes/speedpad_entry.dart';
import 'package:shared_classes/src/serialization/serializable.dart';
import 'package:shared_classes/shared_classes.dart';

class LinkEntry extends SpeedpadEntry implements Serializable {
  String url;
  TabEntry parent;

  LinkEntry(String name, TabEntry parent, this.url, String img) : super(SpeedpadEntryType.Link) {
    entryName = name;
    entryImage = img;
    if (parent.type != LinkEntry) {
      this.parent = parent;
    } else {
      throw new Exception("Illegal Argument for SpeedpadEntry parent parameter");
    }
  }

  Map toMap() {
    var map = {"url": url, "parent": parent};
    map.addAll(super.toMap());
    return map;
  }

  LinkEntry.fromMap(Map map) : super.fromMap(map) {
    parent = map['parent'];
    url = map['url'];
  }

  String toString() {
    return "${parent.entryName}:${parent.tabId} - $entryName $url";
  }
}
