class AppRequest {
  static Map<String, String> headers([String? bearerToken]) {
    if (bearerToken == null) {
      return {
        'Accept': 'application/json',
      };
    } else {
      return {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };
    }
  }
}
