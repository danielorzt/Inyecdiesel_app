// Ruta: lib/core/errors/exceptions.dart

/// Excepción que ocurre cuando hay un error en el servidor
class ServerException implements Exception {}

/// Excepción que ocurre cuando hay un error en la caché local
class CacheException implements Exception {}

/// Excepción que ocurre cuando hay un error en la autenticación
class AuthException implements Exception {}

// Ruta: lib/core/errors/failure.dart

import 'package:equatable/equatable.dart';

/// Clase base para todos los fallos
abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Fallo cuando hay un error en el servidor
class ServerFailure extends Failure {}

/// Fallo cuando hay un error en la caché local
class CacheFailure extends Failure {}

/// Fallo cuando hay un error en la conexión
class ConnectionFailure extends Failure {}

/// Fallo cuando hay un error en la autenticación
class AuthFailure extends Failure {}