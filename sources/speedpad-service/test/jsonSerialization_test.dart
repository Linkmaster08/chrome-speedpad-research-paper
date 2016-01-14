library json_serialization_test;

import 'package:test/test.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_classes/shared_classes.dart';

void main() {
  var homeGroupHash = CryptoUtils.bytesToHex((new SHA1()
    ..add("Home".codeUnits)).close());

  var testStructureJson = '[{"filename":"70f8bb9a8a5393ef080507a89e4b98d139000d65",'
      '"usesImage":false,'
      '"entryType":"SpeedpadEntryType.Tab",'
      '"entryName":"Home",'
      '"entryImage":"css/img/missing_screen.png"}]';

  List<TabEntry> testStructure = [];
  testStructure.add(new TabEntry("Home"));

  group("Structure JSON Test: ", () {
    test("Structure to JSON ", () {
      var json = JSON.encode(testStructure);
      expect(json, equals(testStructureJson));
    });

    test("JSON to Structure ", () {
      List structureRawDecode = JSON.decode(testStructureJson);
      var structure = structureRawDecode.map(
          (Map map) => new TabEntry.fromMap(map))
      .toList();
      expect(structure[0].runtimeType.toString(), equals("TabEntry"));
    });
  });

  Map<String, List<LinkEntry>> links = new Map<String, List<LinkEntry>>();

  group("TabEntry content list json: ", () {

    test("Basic JSON Encode", () {
      if (links[homeGroupHash] == null) {
        links[homeGroupHash] = new List<LinkEntry>();
      }
//      LinkEntry link = new LinkEntry("Apple", homeGroupHash,  "http://apple.de", "css/img/missing_screen.png");
//      links[homeGroupHash].add(link);

    });

    test("Basic JSON Decode", () {

    });

  });

}
