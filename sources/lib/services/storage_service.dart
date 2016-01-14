library speedpad_extension.storage_service;

import 'package:event_bus/event_bus.dart';
import 'package:angular/angular.dart';

import 'package:shared_classes/shared_classes.dart';
import 'package:speedpad/util/service_connection_manager.dart';
import 'package:speedpad/event_classes/events.dart';
import 'package:speedpad/global/logging_identifiers.dart';
import 'package:logging/logging.dart';

@Injectable()
class StorageService {
  ServiceConnectionManager _service;
  EventBus _eventBus;

  final Logger _logger = new Logger("$SpeedpadExtensionID.StorageService");

  StorageService(this._eventBus, this._service) {
    _service.sendToSpeedpadService(new TransferObject.Request(RequestType.getStructure));
  }

  ///redirects request to ServiceConnectionManager
  void requestLinksInTab(String tabId) {
    _service.sendToSpeedpadService(new TransferObject.Request(RequestType.getLinksForTab)..params['tabId'] = tabId);
  }

  void saveLinksInTab(String tabId, List<LinkEntry> links) {
    _service.sendToSpeedpadService(new TransferObject.Request(RequestType.saveLinksForTab)
      ..params['tabId'] = tabId
      ..params.addObjectAsString('data', links));
  }
}
