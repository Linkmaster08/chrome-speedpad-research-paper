library serialization_helper;

import 'dart:convert';
import 'package:serialization/serialization.dart';
import 'package:shared_classes/shared_classes.dart';
import 'package:shared_classes/src/serialization/base_serialization.dart';
import 'package:shared_classes/src/serialization/request_enum_serialization.dart';
import 'package:shared_classes/src/serialization/response_enum_serialization.dart';
import 'package:shared_classes/src/logging_identifiers.dart';
import 'package:logging/logging.dart';

final Serialization _serialization = new Serialization()
  ..addRule(new BaseSerialisation<TabEntry>((state) => new TabEntry.fromMap(state)))
  ..addRule(new BaseSerialisation<LinkEntry>((state) => new LinkEntry.fromMap(state)))
  ..addRule(new BaseSerialisation<FolderEntry>((state) => new FolderEntry.fromMap(state)))
  ..addRule(new BaseSerialisation<TransferObject>((state) => new TransferObject.fromMap(state)))
  ..addRule(new BaseSerialisation<ParameterBag>((state) => new ParameterBag.fromMap(state)))
  ..addRule(new RequestEnumSerialization())
  ..addRule(new ResponseEnumSerialization());

final Logger _logger = new Logger("$SharedClassesKey.serialization.helper");

dynamic serialize(object) => serializeToJson(object);

dynamic deserialize(serialized) => deserializeFromJson(serialized);

String serializeToJson(object) => JSON.encode(serializeToMap(object));

dynamic deserializeFromJson(String json) => deserializeFromMap(JSON.decode(json));

Map serializeToMap(object) {
  _logger.finest("Serialize ${object.runtimeType}");
  return _serialization.write(object, format: new SimpleMapFormat());
}

dynamic deserializeFromMap(Map map) {
  var output = _serialization.read(map, format: new SimpleMapFormat());
  _logger.finest("Deserialized ${output.runtimeType}");
  return output;
}
