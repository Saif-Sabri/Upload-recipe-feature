import 'package:dartz/dartz.dart';

import '/core/exceptions/service_failure.dart';
import '/domain/entities/video_model.dart';

abstract class VideoRepository {
  Future<Either<Failure, Video>> uploadVideo();
}
