import '/domain/entities/video_model.dart';

abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoSuccess extends VideoState {
  final Video video;

  VideoSuccess({required this.video});
}

class VideoFailure extends VideoState {
  final String message;

  VideoFailure({required this.message});
}
