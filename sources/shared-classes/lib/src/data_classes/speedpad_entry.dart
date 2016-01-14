library speedpad_entry;

///A model base class for representing a generic entry in Speedpad-Extension
abstract class SpeedpadEntry {
  ///Type of that entry
  ///Could be something from [SpeedpadEntryType]
  SpeedpadEntryType type;

  ///Name of that entry
  String entryName;

  ///Image for that entry as data url or package local url
  String entryImage;

  SpeedpadEntry(SpeedpadEntryType this.type) {
  }

  SpeedpadEntry.fromMap(Map json) {
    type = _decodeEntryType(json['entryType']);
    entryName = json['entryName'];
    entryImage = json['entryImage'];
  }

  ///serializes the data in this entry to a map
  ///
  /// will be used to build a json representation in child classes
  Map toMap() {
    var map = {
      'entryType': type.toString(),
      'entryName': entryName,
      'entryImage': entryImage
    };
    return map;
  }

  ///decodes the string representation of [SpeedpadEntryType]
  SpeedpadEntryType _decodeEntryType(String entryType) {
    List<SpeedpadEntryType> entryTypes = SpeedpadEntryType.values;
    return entryTypes.firstWhere((element) => element.toString() == entryType);
  }
}

///defines the types for a [SpeedpadEntry]
enum SpeedpadEntryType {
  Folder, Tab, Link
}
