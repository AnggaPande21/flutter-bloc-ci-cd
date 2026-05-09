import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure that occurs when there's a server error
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure that occurs when there's a network connection issue
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure that occurs when data parsing fails
class DataParsingFailure extends Failure {
  const DataParsingFailure(super.message);
}
