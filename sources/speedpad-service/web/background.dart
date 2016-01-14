library service_background_script;

import 'package:shared_classes/shared_classes.dart';
import 'package:chrome/chrome_app.dart' as chrome;
import 'package:speedpad_service/file_helper.dart';
import 'package:speedpad_service/storage_service.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:speedpad_service/logging_identifiers.dart';

import 'package:shared_classes/src/serialization/serialisation_helper.dart';

final String _extensionId = "mcnkcgagkphmchobiekikidpgbbemdcc";

final Logger _logger = new Logger("$SpeedpadServiceID.background");
final Logger _libLogger = new Logger("$SpeedpadServiceID");
FileHelper fileHelper;
StorageService storageService;
Map<String, chrome.Port> ports = new Map<String, chrome.Port>();

main() {
  //listen for connections
  chrome.runtime.onConnectExternal.listen((chrome.Port port) async {
    //init logging
    hierarchicalLoggingEnabled = true;
    Logger.root.onRecord.listen(new LogPrintHandler());

    Logger.root.level = Level.OFF;
    _libLogger.level = Level.ALL;
    //could be customized with _libLogger.level =  Level.INFO or Level.OFF and
    // then add specific logger
    //_logger.level = Level.All

    if (port.sender.id != _extensionId) {
      _logger.shout("connection not authorized, rejecting");
      return;
    } else {
      _logger.info("connection established: Port number: ${port.name}");
      ports[port.name] = port;
    }
    //handle onDisconnect
//    port.onDisconnect.listen((data)=>
//    print("connection closed"));

    if (storageService == null) {
      storageService = await StorageService.createStorageService();
    }

    installMessageListener(port);
  });

  chrome.app.runtime.onLaunched.listen((launchData) {
    _logger.warning("service launched - useless without connection");
  });
}

void sendToExtension(port, TransferObject transfer) {
  if (port != null) {
    _logger.finest("sendToExtension: ${transfer.responseType}");
    port.postMessage(transfer.serialize());
  } else {
    //TODO: output error message
    _logger.shout("No connection available");
  }
}

void installMessageListener(chrome.Port port) {
  //Listen for Messages and answer them
  port.onMessage.listen((chrome.OnMessageEvent event) async {
    TransferObject request = deserialize(event.message);

    _logger.finest(request.requestType);

    switch (request.requestType) {
      case RequestType.getStructure:
        TransferObject response = new TransferObject.Response(ResponseType.structure);
        var structure = await storageService.getLinkStructure();
        response.params['data'] = structure;
        sendToExtension(port, response);
        break;
      case RequestType.getLinksForTab:
        _logger.finest("getLinksForTab - tabId: ${request.params['tabId']}");
        var links = await storageService.getLinksInTab(request.params['tabId']);
        TransferObject response = new TransferObject.Response(ResponseType.linksForTab);
        response.params['tabId'] = request.params['tabId'];
        response.params['data'] = links;
        sendToExtension(port, response);
        break;
      case RequestType.saveLinksForTab:
        TransferObject response = new TransferObject.Response(ResponseType.message);
        storageService.saveLinksInTab(request.params['tabId'], request.params['data']);
        sendToExtension(port, response);
        break;
    }
  });

  //notify client that server connection is ready for listening
  TransferObject clientNotification = new TransferObject.Response(ResponseType.connectionReady);
  sendToExtension(port, clientNotification);
}
