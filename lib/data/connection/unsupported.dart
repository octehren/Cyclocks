// unsupported.dart
import 'package:drift/drift.dart';
// QueryExecutor implements DatabaseConnection
QueryExecutor openConnection() {
  // EXPLANATION: This file serves as a fallback for the conditional import in `database.dart`. If the app is compiled for a platform that has neither `dart:io` nor `dart:library.html` (which is very rare), this implementation will be used. It immediately throws an error, making it clear that the platform is not supported.
  throw UnimplementedError("Platform is incompatible with the application.");
}