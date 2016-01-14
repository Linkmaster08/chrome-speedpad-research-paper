part of events;

/**
 * Class for updating the main launchpad canvas
 */
class UpdateLaunchpadCanvas {

  ///the tab related to this update
  String tabId;

  ///content links for the related tab
  List<LinkEntry> links;

  UpdateLaunchpadCanvas(this.tabId, this.links);


}
