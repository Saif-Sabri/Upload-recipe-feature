import '/domain/entities/recipe_model.dart';

abstract class RecipesEvent {}

class LoadRecipesEvent extends RecipesEvent {}

class AddRecipeEvent extends RecipesEvent {
  final Recipe recipe;
  AddRecipeEvent({
    required this.recipe,
  });
}

class CloseServiceEvent extends RecipesEvent {}
