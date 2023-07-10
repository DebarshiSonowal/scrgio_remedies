class IndividualImageResponse {
  bool? error;
  String? image, message;

  IndividualImageResponse.fromJson(json) {
    error = json['error'] ?? true;
    image = json['data']['image']??"";
  }
  IndividualImageResponse.withError(msg){
    error = true;
    message = msg;
  }
}
