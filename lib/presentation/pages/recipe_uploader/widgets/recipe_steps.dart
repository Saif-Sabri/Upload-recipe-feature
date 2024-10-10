import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/domain/entities/recipe_model.dart';

import '/presentation/bloc/recipe/recipe_bloc.dart';
import '/presentation/bloc/recipe/recipe_event.dart';
import '/presentation/bloc/recipe_steps/recipe_steps_bloc.dart';
import '/presentation/bloc/recipe_steps/recipe_steps_event.dart';
import '/presentation/bloc/video/video_bloc.dart';
import '/presentation/bloc/video/video_state.dart';

class RecipeSteps extends StatefulWidget {
  const RecipeSteps({super.key});

  @override
  State<RecipeSteps> createState() => _RecipeStepsState();
}

class _RecipeStepsState extends State<RecipeSteps> {
  final _formKey = GlobalKey<FormState>();
  Recipe recipe = Recipe(
    id: '1',
    name: 'Recipe Name',
    steps: [],
    videoUrl: '',
  );
  List<TextEditingController> controllers = [];

  RecipeStepsBloc? recipeBloc;
  VideoBloc? videoBloc;
  VideoState? videoState;

  @override
  void initState() {
    super.initState();
    recipeBloc = context.read<RecipeStepsBloc>();
    videoBloc = context.read<VideoBloc>();
    videoState = videoBloc!.state;
  }

  void _addStep() {
    setState(
      () {
        int stepNumber = recipe.steps.length + 1;
        String stepName = 'Step $stepNumber';

        recipe.steps.add(
          StepInstruction(
            name: stepName,
            beginTime: recipe.steps.length + 5,
            endTime: recipe.steps.length + 7,
            instruction: '',
          ),
        );
        controllers.add(TextEditingController());
      },
    );
  }

  void _removeStep() {
    setState(
      () {
        recipe.steps.removeLast();
      },
    );
  }

  void _validateSteps() async {
    if (_formKey.currentState!.validate()) {
      for (int i = 0; i < recipe.steps.length; i++) {
        String instruction = controllers[i].text;
        recipe.steps[i].instruction = instruction;
      }

      // await videoBloc!.stream.firstWhere(
      //   (state) => state is VideoSuccess,
      // );

      VideoSuccess videoState = videoBloc!.state as VideoSuccess;

      recipeBloc!.add(
        AddRecipeStep(
          recipe: recipe,
        ),
      );
      recipe.videoUrl = videoState.video.xFile.path;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The recipe steps have been added.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the instructions.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (TextEditingController controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoBloc, VideoState>(
      listener: (context, state) {
        setState(() {
          videoState = state;
        });
      },
      child: Visibility(
        visible: videoState is VideoSuccess,
        replacement: const Text('Upload a video to fill steps\' instruction.'),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add recipe steps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        recipe.steps.isEmpty ? null : _validateSteps(),
                    icon: Icon(
                      Icons.check,
                      color: recipe.steps.isEmpty ? Colors.grey : Colors.green,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView.builder(
                  itemCount: recipe.steps.length,
                  itemBuilder: (context, index) {
                    String step = recipe.steps[index].name;
                    return ListTile(
                      title: Text(step),
                      subtitle: TextFormField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          hintText: 'Enter instructions for $step',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill the instruction.';
                          }
                          return null;
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addStep,
                  child: const Text('Add Step'),
                ),
                ElevatedButton(
                  onPressed: recipe.steps.isEmpty ? null : _removeStep,
                  child: const Text('Remove Step'),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.save,
              ),
              onPressed: () {
                context.read<RecipesBloc>().add(
                      AddRecipeEvent(recipe: recipe),
                    );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
