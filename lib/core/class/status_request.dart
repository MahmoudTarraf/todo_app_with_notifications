enum StatusRequest {
  loading,
  success,
  failure,
  serverFailure,
  offlineFailure,
  none,
  error,
  authFailure,
}

/// Wrapper to carry both status and an optional backend error message
class RequestError {
  final StatusRequest status;
  final String? message;

  const RequestError(this.status, {this.message});

  @override
  String toString() {
    return "RequestError(status: $status, message: $message)";
  }
}
