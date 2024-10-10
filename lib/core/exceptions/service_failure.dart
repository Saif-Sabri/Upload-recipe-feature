abstract class Failure {}

class ServiceFailure extends Failure {
  final String message;

  ServiceFailure({
    required this.message,
  });

  @override
  String toString() => message;
}
