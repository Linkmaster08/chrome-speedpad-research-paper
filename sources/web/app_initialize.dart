library app_init;

import 'package:angular/application_factory.dart';
import 'package:speedpad/speedpad_app.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:speedpad/services/storage_service.dart';
import 'package:speedpad/global/logging_identifiers.dart';

final Logger _libLogger = new Logger("$SpeedpadExtensionID");

void main () {
  //init logging
  hierarchicalLoggingEnabled = true;
  Logger.root.onRecord.listen(new LogPrintHandler());

  Logger.root.level = Level.OFF;
  _libLogger.level = Level.ALL;
  //could be customized with _libLogger.level =  Level.INFO or Level.OFF and
  // then add specific logger
  //_logger.level = Level.All

// Hint for using injector:
// final injector = applicationFactory().addModule(new SpeedpadApp()).run();
  final injector = applicationFactory().addModule(new SpeedpadApp()).run();
  //for StorageService init to start connection
  var storage = injector.get(StorageService);
}