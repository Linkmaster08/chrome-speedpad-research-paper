library shared_classes.response_enum_serialization;
import 'package:serialization/serialization.dart';
import 'package:shared_classes/src/response_enum.dart';

class ResponseEnumSerialization extends CustomRule {


  ResponseType create(state) {
    List<ResponseType> values = ResponseType.values;
    return values.firstWhere((element) => element.toString() == state[0]);
  }

  void setState(object, List state) {
    //do nothing
  }


  getState(ResponseType instance) {
    return [instance.toString()];
  }


  bool appliesTo(instance, Writer w) {
    return instance.runtimeType == ResponseType;
  }


}