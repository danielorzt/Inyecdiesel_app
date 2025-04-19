// Ruta: lib/features/shipping/domain/usecases/get_shipping_by_id.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/repositories/shipping_repository.dart';

class GetShippingById {
  final ShippingRepository repository;

  GetShippingById(this.repository);

  Future<Either<Failure, ShippingEntity>> call(Params params) {
    return repository.getShippingById(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id});

  @override
  List<Object?> get props => [id];
}

// Ruta: lib/features/shipping/domain/usecases/create_shipping.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/repositories/shipping_repository.dart';

class CreateShipping {
  final ShippingRepository repository;

  CreateShipping(this.repository);

  Future<Either<Failure, ShippingEntity>> call(ShippingEntity shipping) {
    return repository.createShipping(shipping);
  }
}

// Ruta: lib/features/shipping/domain/usecases/update_shipping.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/repositories/shipping_repository.dart';

class UpdateShipping {
  final ShippingRepository repository;

  UpdateShipping(this.repository);

  Future<Either<Failure, ShippingEntity>> call(ShippingEntity shipping) {
    return repository.updateShipping(shipping);
  }
}

// Ruta: lib/features/shipping/domain/usecases/update_shipping_status.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/repositories/shipping_repository.dart';

class UpdateShippingStatus {
  final ShippingRepository repository;

  UpdateShippingStatus(this.repository);

  Future<Either<Failure, ShippingEntity>> call(Params params) {
    return repository.updateShippingStatus(params.id, params.status);
  }
}

class Params extends Equatable {
  final String id;
  final ShippingStatus status;

  const Params({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}