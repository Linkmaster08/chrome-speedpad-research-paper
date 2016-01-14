library tab_entry;

import 'package:shared_classes/src/data_classes/speedpad_entry.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_classes/src/serialization/serializable.dart';

class TabEntry extends SpeedpadEntry implements Serializable {

  ///Name of the file where the content entries for that tab are located
  String tabId;

  ///defines whether an image is used for that tab or not
  bool usesImage = false;

  ///Index for identifying the content entries for that tab in a list
  ///Will not be stored in Filesystem!
  ///If null -> reading function will load the entries for that tab
  int index;

  TabEntry(String name) : super(SpeedpadEntryType.Tab) {
    entryName = name;
    tabId = CryptoUtils.bytesToHex((new SHA1()
      ..add(name.codeUnits)).close());
    entryImage = "css/img/missing_screen.png";
  }

  TabEntry.fromMap(Map json) : super.fromMap(json) {
    tabId = json['filename'];
    usesImage = json['usesImage'];
  }

  Map toMap() {
    var map = {
      "filename": tabId,
      "usesImage": usesImage
    };
    map.addAll(super.toMap());
    return map;
  }

}
