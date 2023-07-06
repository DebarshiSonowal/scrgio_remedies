class GenericResponse {
  String? message;
  bool? error;
  String? token;

  GenericResponse.fromJson(json) {
    error = json['error'] ?? true;
    message = json['message'] ?? "Something went wrong";
    token = json['data']['token'];
  }

  GenericResponse.withError(msg) {
    error = true;
    message = msg;
  }
}
