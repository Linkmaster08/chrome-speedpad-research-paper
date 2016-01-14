library tools;

int extractErrorCodeFromMessage (String errorMessage) {
  var index = errorMessage.indexOf("error code: ");
  return int.parse(errorMessage.substring(index + 12, index + 16));
}