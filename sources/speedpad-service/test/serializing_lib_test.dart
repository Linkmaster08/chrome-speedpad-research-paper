library json_serialization_test;

import 'package:test/test.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_classes/shared_classes.dart';
import 'package:serialization/serialization.dart';

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

  Serialization serialization;

  setUp(() {
//    serialization = new Serialization()
//      ..addRule(new TabEntrySerializationRule());
  });

  group("Encode/decode Tests: ", () {
    test("Structure Objects to JSON and back ", () {
      var json = JSON.encode(serialization.write(
          testStructure, format: new SimpleMapFormat()));
      var object = serialization.read(
          JSON.decode(json), format: new SimpleMapFormat());
      expect(object, new isInstanceOf<List<TabEntry>>());
    });
  });

  Map<String, List<LinkEntry>> links = new Map<String, List<LinkEntry>>();
}
