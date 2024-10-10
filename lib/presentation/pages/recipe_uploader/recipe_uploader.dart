import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/injection_container.dart';

import '/presentation/bloc/recipe/recipe_bloc.dart';
import '/presentation/bloc/recipe_steps/recipe_steps_bloc.dart';
import '/presentation/bloc/video/video_bloc.dart';

import 'widgets/recipe_steps.dart';
import 'widgets/video_picker.dart';

class RecipeUploader extends StatelessWidget {
  const RecipeUploader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text(
            'Add a recipe',
          ),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<RecipesBloc>(
              create: (context) => getIt<RecipesBloc>(),
            ),
            BlocProvider<VideoBloc>(
              create: (context) => getIt<VideoBloc>(),
            ),
            BlocProvider<RecipeStepsBloc>(
              create: (context) => getIt<RecipeStepsBloc>(),
            ),
          ],
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: VideoPicker(),
              ),
              Expanded(
                child: RecipeSteps(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
