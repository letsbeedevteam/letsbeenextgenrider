import 'base/failure.dart';

class ServerFailure extends Failure {
  static const defaultMessage = 'Server Failure';
  const ServerFailure([String message = defaultMessage]) : super(message);
}

class AuthenticationFailure extends Failure {
  static const defaultMessage = 'Authentication Failure';
  const AuthenticationFailure([String message = defaultMessage])
      : super(message);
}

class UnauthorizedFailure extends Failure {
  static const defaultMessage = 'Unauthorized Failure';
  const UnauthorizedFailure([String message = defaultMessage]) : super(message);
}

class ConnectionFailure extends Failure {
  static const defaultMessage = 'Connection Failure';
  const ConnectionFailure([String message = defaultMessage]) : super(message);
}

class CacheFailure extends Failure {
  static const defaultMessage = 'Cache Failure';
  const CacheFailure([String message = defaultMessage]) : super(message);
}
