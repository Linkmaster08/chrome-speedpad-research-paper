library shared_classes.transfer_object;

import 'package:shared_classes/shared_classes.dart';
import 'package:shared_classes/src/serialization/serialisation_helper.dart' as helper;
import 'package:shared_classes/src/serialization/serializable.dart';

class TransferObject implements Serializable {
  static final String _TRANSFER_REQUEST_TYPE_PARAMETER = "TRANSFER_REQUEST_TYPE_PARAMETER";
  static final String _TRANSFER_RESPONSE_TYPE_PARAMETER = "TRANSFER_RESPONSE_TYPE_PARAMETER";
  ParameterBag params = new ParameterBag();

  TransferObject.Request(RequestType type) {
    params[_TRANSFER_REQUEST_TYPE_PARAMETER] = type;
  }

  TransferObject.Response(ResponseType type) {
    params[_TRANSFER_RESPONSE_TYPE_PARAMETER] = type;
  }

  TransferObject.fromMap(Map map) {
    params = map['params'];
  }

  @override
  Map toMap() => {'params': params};

  get requestType => params[_TRANSFER_REQUEST_TYPE_PARAMETER];
  get responseType => params[_TRANSFER_RESPONSE_TYPE_PARAMETER];

  serialize () => helper.serialize(this);
}
