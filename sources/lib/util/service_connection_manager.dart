library speedpad_extension_service_connection_manager;

import 'dart:math';

import 'package:chrome/chrome_ext.dart' as chrome;
import 'package:shared_classes/shared_classes.dart';
import 'package:event_bus/event_bus.dart';
import 'package:angular/angular.dart';
import 'package:speedpad/event_classes/events.dart';
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:speedpad/global/logging_identifiers.dart';

@Injectable()
class ServiceConnectionManager {
  static const _finalAppId = "mdihmfohgbipkhphhpjmecakkplkiedp";

  EventBus _eventBus;
  chrome.Port _port;

  Completer<bool> _connectionReadyCompleter = new Completer<bool>();
  Future<bool> isConnectionReady;

  final Logger _logger = new Logger("$SpeedpadExtensionID.ServiceConnectionManager");

  ///constructor
  ServiceConnectionManager(this._eventBus) {
    var connectionNumber = new Random().nextInt(100000);
    isConnectionReady = _connectionReadyCompleter.future;
    _connect(connectionNumber);
  }

  void _connect(int connectionNumber) {
    //connect to Speedpad Service for storage access
    var params = new chrome.RuntimeConnectParams();
    params.name = connectionNumber.toString();

    _port = chrome.runtime.connect(_finalAppId, params);

    _port.onMessage.listen((chrome.OnMessageEvent event) {
      TransferObject response = deserialize(event.message);
      _logger.fine("Message from service: ${response.responseType}");

      switch (response.responseType) {
        case ResponseType.structure:
          var data = deserialize(response.params['data']);
          _logger.finer("data: ${data}");
          _eventBus.fire(new UpdateStructure(data));
          break;
        case ResponseType.linksForTab:
          var tabId = response.params['tabId'];
          var data = response.params.getObjectFromString('data');
          _logger.finest("linksForTab");
          _eventBus.fire(new UpdateLaunchpadCanvas(tabId, data));
          break;
        case ResponseType.message:
          _logger.info(response.params['message']);
          break;
        case ResponseType.connectionReady:
          _logger.info("Connection to server ready for sending data");
          _connectionReadyCompleter.complete(true);
          break;
      }
    });
  }

  void sendToSpeedpadService(TransferObject transfer) {
    _logger.fine("sendToSpeedpadService: ${transfer.requestType}");

    isConnectionReady.then((_) {
      if (_port != null) {
        Map content = serialize(transfer);
        _port.postMessage(content);
      } else {
        //TODO: output error message
        _logger.shout("No connection available!");
        print("no connection avaliable");
      }
    });
  }
}
