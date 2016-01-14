library link_component;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:shared_classes/shared_classes.dart';
import 'package:speedpad/global/logging_identifiers.dart';
import 'package:logging/logging.dart';

@Component(
    selector: "link-component",
    templateUrl: "packages/speedpad/link_component/link_component.html",
    useShadowDom: false
)
class LinkComponent implements AttachAware{

  Logger _logger = new Logger("$SpeedpadExtensionID.LinkComponent");

  @NgOneWay('link-entry')
  LinkEntry link;


  void navigate() {
    window.location.href = link.url;
  }


  @override
  void attach() {
    _logger.finest(link);
  }
}