import 'package:dartz/dartz.dart';

import '/core/exceptions/service_failure.dart';
import '/domain/entities/video_model.dart';
import '/domain/repositories/video_repository.dart';

class UploadVideoUseCase {
  final VideoRepository _videoRepository;

  UploadVideoUseCase(this._videoRepository);

  Future<Either<Failure, Video>> call() {
    return _videoRepository.uploadVideo();
  }
}
