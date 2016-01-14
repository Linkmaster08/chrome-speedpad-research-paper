library shared_classes.request_enum_serialization;
import 'package:serialization/serialization.dart';
import 'package:shared_classes/src/request_enum.dart';

class RequestEnumSerialization extends CustomRule {


  RequestType create(state) {
    List<RequestType> values = RequestType.values;
    return values.firstWhere((element) => element.toString() == state[0]);
  }

  void setState(object, List state) {
    //do nothing
  }


  getState(RequestType instance) {
    return [instance.toString()];
  }


  bool appliesTo(instance, Writer w) {
    return instance.runtimeType == RequestType;
  }


}