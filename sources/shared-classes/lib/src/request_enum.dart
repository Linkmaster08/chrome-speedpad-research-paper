library shared_classes.request_enum;

enum RequestType {
  ///gets List<TabEntry> from structure file
  ///
  ///@param no
  ///@response [ResponseType.structure]
  getStructure,

  /// gets List<LinkEntry> for specific tab
  ///
  ///@param  tabId = String
  ///@response [ResponseType.linksForTab]
  getLinksForTab,

  ///saves a complete tab structure  of one tab
  ///
  ///@param tabId = String
  ///@param data = string of List<[LinkEntry]>
  ///@response [ResponseType.message]
  saveLinksForTab
}
