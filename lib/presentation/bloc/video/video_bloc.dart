import 'package:flutter_bloc/flutter_bloc.dart';

import 'video_event.dart';
import 'video_state.dart';

import '/domain/use_cases/video/upload_video.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final UploadVideoUseCase uploadVideo;

  VideoBloc({required this.uploadVideo}) : super(VideoInitial()) {
    on<PickVideo>((event, emit) async {
      emit(VideoLoading());
      final video = await uploadVideo();
      video.fold(
        (fail) => emit(
          VideoFailure(
            message: fail.toString(),
          ),
        ),
        (success) => emit(
          VideoSuccess(
            video: success,
          ),
        ),
      );
    });
  }
}
