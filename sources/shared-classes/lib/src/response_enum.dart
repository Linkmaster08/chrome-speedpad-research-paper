library shared_classes.response_enum;

enum ResponseType {
  ///Response to  [RequestType.getStructure]
  ///@param data = String of List<[TabEntry]>
  structure,

  ///Response to [RequestType.getLinksForTab]
  ///
  ///@param hashedTabName = String
  ///@param data = string of List<[LinkEntry]>
  linksForTab,

  /// general message response
  ///
  /// @used for [RequestType.saveLinksForTab]
  ///
  message,

  ///will be send after connection initialize
  connectionReady
}
