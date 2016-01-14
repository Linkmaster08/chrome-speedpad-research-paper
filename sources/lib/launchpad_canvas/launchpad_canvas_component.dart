library launchpad_canvas;

import 'package:angular/angular.dart';
import 'dart:html';
import 'package:event_bus/event_bus.dart';
import 'package:speedpad/event_classes/events.dart';
import 'package:speedpad/services/storage_service.dart';
import 'package:shared_classes/shared_classes.dart';
import 'package:speedpad/global/logging_identifiers.dart';
import 'package:logging/logging.dart';

@Component(
    selector: "launchpad-canvas",
    templateUrl: "packages/speedpad/launchpad_canvas/launchpad_canvas.html",
    useShadowDom: false)
class LaunchpadCanvas implements ShadowRootAware {
  EventBus _eventBus;
  StorageService storageService;
  Element self;
  String currentTabId;

  final Logger _logger = new Logger("$SpeedpadExtensionID.LaunchpadCanvasComponent");

  ///A list for holding structure information of Speedpad Entries, e.g. [TabEntry] instances
  List<TabEntry> structure = [];

  ///map holds association from tab name hashes (filenames) to List with LinkEntries
  Map<String, List<LinkEntry>> links = new Map<String, List<LinkEntry>>();

  LaunchpadCanvas(this.self, this._eventBus, this.storageService) {
    ///cache structure when arriving as response
    _initUpdateStrutureListener();

    ///init event handler for SaveLink event
    _initSaveLinkListener();

    ///init UpdateLaunchpad event listener
    _eventBus.on(UpdateLaunchpadCanvas).listen((UpdateLaunchpadCanvas launchpadUpdate) {
      _logger.info("Launchpad gets updated!");
      links[launchpadUpdate.tabId] = launchpadUpdate.links;
      currentTabId = launchpadUpdate.tabId;
    });
  }

  void _initSaveLinkListener() {
    _eventBus.on(SaveLink).listen((SaveLink event) {
      print("SaveLink event: ${event.link.toString()}");
      String tabId = event.link.parent.tabId;
      print("TabId: $tabId");
      if (links[tabId] == null) {
        links[tabId] = new List<LinkEntry>();
      }

      //set current tab to tab id where icon was safed to show the action to the user
      if (currentTabId != tabId) {
        currentTabId = tabId;
      }

      links[tabId].add(event.link);

      storageService.saveLinksInTab(tabId, links[tabId]);
    });
  }

  void _initUpdateStrutureListener() {
    _eventBus.on(UpdateStructure).listen((UpdateStructure response) {
      structure = response.structure;
      //query first available group
      _logger.finest("EventBus on ");
      storageService.requestLinksInTab(structure[0].tabId);
    });
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    self.style
      ..display = "block"
      ..position = "absolute"
      ..height = "100%"
      ..right = "120px"
      ..left = "10px";
  }
}
