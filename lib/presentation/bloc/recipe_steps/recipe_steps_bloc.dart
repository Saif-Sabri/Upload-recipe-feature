import 'package:flutter_bloc/flutter_bloc.dart';

import 'recipe_steps_event.dart';
import 'recipe_steps_state.dart';

import '/domain/use_cases/recipe/add_recipe_steps.dart';

class RecipeStepsBloc extends Bloc<RecipeStepsEvent, RecipeStepsState> {
  final AddRecipeStepsUseCase addRecipeSteps;

  RecipeStepsBloc({required this.addRecipeSteps})
      : super(RecipeStepsInitial()) {
    on<AddRecipeStep>((event, emit) async {
      emit(RecipeStepsLoading());
      final recipe = await addRecipeSteps(event.recipe);
      recipe.fold(
        (fail) => emit(
          RecipeStepsFailure(
            message: fail.toString(),
          ),
        ),
        (success) => emit(
          RecipeStepsSuccess(
            recipe: success,
          ),
        ),
      );
    });
  }
}
