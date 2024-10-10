import '/domain/entities/recipe_model.dart';

abstract class RecipeStepsEvent {}

class AddRecipeStep extends RecipeStepsEvent {
  final Recipe recipe;

  AddRecipeStep({
    required this.recipe,
  });
}
