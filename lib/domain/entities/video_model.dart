import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Video extends Equatable {
  final String id;
  final String? name;
  final XFile xFile;
  final VideoPlayerController videoPlayerController;

  const Video({
    required this.id,
    this.name,
    required this.xFile,
    required this.videoPlayerController,
  });

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
