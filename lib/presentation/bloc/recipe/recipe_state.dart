import '/domain/entities/recipe_model.dart';

abstract class RecipesState {}

class RecipesInitial extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesSuccess extends RecipesState {
  final List<Recipe> recipes;

  RecipesSuccess({
    required this.recipes,
  });
}

class RecipesFailure extends RecipesState {
  final String message;

  RecipesFailure({
    required this.message,
  });
}
