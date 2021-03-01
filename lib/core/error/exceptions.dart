
import 'base/custom_exception.dart';

class ServerException extends CustomException {
  ServerException(String cause) : super(cause);
}

class AuthenticationException extends CustomException {
  AuthenticationException(String cause) : super(cause);
}

class UnauthorizedException extends CustomException {
  UnauthorizedException(String cause) : super(cause);
}

class SocketConnectionException extends CustomException {
  SocketConnectionException(String cause) : super(cause);
}

class CacheException extends CustomException {
  CacheException(String cause) : super(cause);
}