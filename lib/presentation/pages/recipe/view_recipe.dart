import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '/domain/entities/recipe_model.dart';

class ViewRecipe extends StatefulWidget {
  final Recipe recipe;
  const ViewRecipe({
    super.key,
    required this.recipe,
  });

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  VideoPlayerController? _videoController;

  ChewieController? _chewieController;

  /// The instruction to be shown on the video.
  String? _currentInstruction;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(
      File(
        widget.recipe.videoUrl!,
      ),
    );
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
    _videoController?.addListener(() {
      final currentPosition = _videoController!.value.position;

      setState(() {
        // Find the instruction that matches the current video time.
        for (StepInstruction step in widget.recipe.steps) {
          if (currentPosition >= Duration(seconds: step.beginTime) &&
              currentPosition <= Duration(seconds: step.endTime)) {
            _currentInstruction = step.instruction;
          } else {
            _currentInstruction = null;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _videoController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.id),
        ),
        body: Column(
          children: [
            Text(
              widget.recipe.name,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 1.77,
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
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.recipe.steps.length,
                itemBuilder: (context, index) {
                  return Text(
                      'Step $index: ${widget.recipe.steps[index].instruction}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
