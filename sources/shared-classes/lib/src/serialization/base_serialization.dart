library base_serialization;

import 'package:serialization/serialization.dart';
import 'package:shared_classes/src/serialization/serializable.dart';

class BaseSerialisation<Type extends Serializable> extends CustomRule {
  Function _createImplementation;

  BaseSerialisation(this._createImplementation(Map state));

  bool appliesTo(instance, Writer w) => instance.runtimeType == Type;

  getState(Serializable instance) => instance.toMap();

  void setState(object, List state) {
    //ignore -nothing to do
  }

  create(state) => _createImplementation(state);
}
