import '/domain/entities/recipe_model.dart';

abstract class RecipeStepsState {}

class RecipeStepsInitial extends RecipeStepsState {}

class RecipeStepsLoading extends RecipeStepsState {}

class RecipeStepsSuccess extends RecipeStepsState {
  final Recipe recipe;

  RecipeStepsSuccess({required this.recipe});
}

class RecipeStepsFailure extends RecipeStepsState {
  final String message;

  RecipeStepsFailure({required this.message});
}
