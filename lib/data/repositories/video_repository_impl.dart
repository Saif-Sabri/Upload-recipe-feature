import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:demo/core/exceptions/service_exception.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '/domain/entities/video_model.dart';
import '/domain/repositories/video_repository.dart';
import '/core/exceptions/service_failure.dart';

class VideoRepositoryImpl implements VideoRepository {
  VideoRepositoryImpl();

  @override
  Future<Either<Failure, Video>> uploadVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? videoFile = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (videoFile == null) {
      return Left(
        ServiceFailure(
          message: 'No video selected.',
        ),
      );
    }

    VideoPlayerController videoPlayerController = VideoPlayerController.file(
      File(
        videoFile.path,
      ),
    );

    try {
      await videoPlayerController.initialize();
    } catch (e) {
      videoPlayerController.dispose();
      return Left(
        ServiceFailure(
          message: 'Failed to load the video. Please try again.',
        ),
      );
    }
    final duration = videoPlayerController.value.duration;

    // TODO: 10 seconds is used for testing purposes, change to 30 seconds for production
    if (duration.inSeconds < 10) {
      videoPlayerController.dispose();
      return Left(
        ServiceFailure(
          message: 'The video must be at least 10 seconds long.',
        ),
      );
    } else {
      videoPlayerController.addListener(() {
        if (videoPlayerController.value.hasError) {
          throw ServiceException(
            message:
                'Error loading the video. ${videoPlayerController.value.errorDescription}',
          );
        }
      });
      final Video video = Video(
        id: '${videoFile.name}_${DateTime.now()}',
        name: videoFile.name,
        videoPlayerController: videoPlayerController,
        xFile: videoFile,
      );
      return Right(video);
    }
  }
}
