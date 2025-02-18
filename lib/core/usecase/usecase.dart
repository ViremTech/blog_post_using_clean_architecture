import 'package:blog_post_using_clean_architecture/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<Successtype, Params> {
  Future<Either<Failure, Successtype>> call(Params params);
}

class NoParams {}
