import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '/core/permission_handler.dart';

import '/domain/entities/recipe_model.dart';

import '/presentation/bloc/recipe_steps/recipe_steps_bloc.dart';
import '/presentation/bloc/recipe_steps/recipe_steps_state.dart';
import '/presentation/bloc/video/video_bloc.dart';
import '/presentation/bloc/video/video_event.dart';
import '/presentation/bloc/video/video_state.dart';

class VideoPicker extends StatefulWidget {
  const VideoPicker({super.key});

  @override
  State<VideoPicker> createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> {
  VideoBloc? videoBloc;
  RecipeStepsBloc? recipeStepsBloc;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  /// The instruction to be shown on the video.
  String? _currentInstruction;

  /// To prevent user multiple clicks on picker.
  bool _isPickerOpen = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    videoBloc = context.read<VideoBloc>();
    recipeStepsBloc = context.read<RecipeStepsBloc>();
  }

  Future<void> _pickVideo() async {
    if (_isPickerOpen) return;

    setState(() {
      _isPickerOpen = true;
    });

    videoBloc!.add(
      PickVideo(),
    );

    await videoBloc!.stream.firstWhere(
      (state) => state is VideoSuccess,
    );

    VideoSuccess videoState = videoBloc!.state as VideoSuccess;
    _videoController = videoState.video.videoPlayerController;
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
      );
    });

    // Add a listener to display instructions at specific times.
    _videoController?.addListener(() {
      final currentPosition = _videoController!.value.position;
      _updateInstruction(currentPosition);
    });

    _isPickerOpen = false;
  }

  /// Method to update the instruction based on video playback position.
  void _updateInstruction(Duration currentPosition) async {
    if (recipeStepsBloc!.state is RecipeStepsSuccess) {
      final RecipeStepsSuccess recipeState =
          recipeStepsBloc!.state as RecipeStepsSuccess;

      setState(() {
        // Find the instruction that matches the current video time.
        for (StepInstruction step in recipeState.recipe.steps) {
          if (currentPosition >= Duration(seconds: step.beginTime) &&
              currentPosition <= Duration(seconds: step.endTime)) {
            _currentInstruction = step.instruction;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Add recipe video',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<VideoBloc, VideoState>(
              builder: (context, state) {
                if (state is VideoSuccess) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: Chewie(
                          controller: _chewieController!,
                        ),
                      ),
                      if (_currentInstruction != null)
                        Positioned(
                          bottom: 20,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.black.withOpacity(0.6),
                            child: Text(
                              _currentInstruction!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                } else if (state is VideoFailure) {
                  /// Failure case, the user can retry picking another video.
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      setState(
                        () {
                          _isPickerOpen = false;
                        },
                      );
                    },
                  );
                  return Text(
                    state.message,
                  );
                } else if (state is VideoInitial) {
                  return const Text(
                    'Select a video to upload.',
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: _isPickerOpen ? null : _pickVideo,
            child: const Text('Select Video from Gallery'),
          ),
        ],
      ),
    );
  }
}
