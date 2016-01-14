library shared_classes.parameter_bag;

import 'package:shared_classes/shared_classes.dart';
import 'package:shared_classes/src/serialization/serializable.dart';


class ParameterBag implements Serializable {

  Map<String, dynamic> _parameterBag;


  ParameterBag() {
    _parameterBag = new Map<String, dynamic>();
  }

  ParameterBag.fromMap(Map map) {
    _parameterBag = map['parameterBag'];
  }

  @override
  Map toMap() => {
    'parameterBag':_parameterBag
  };


  void addObjectAsString(String key, object) {
    _parameterBag[key] = serialize(object);
  }

  dynamic getObjectFromString(String key) {
    return deserialize(_parameterBag[key]);
  }

  operator [](String key) => _parameterBag[key];

  operator []=(String key, value) => _parameterBag[key] = value;
}