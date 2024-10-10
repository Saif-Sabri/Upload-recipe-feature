import 'package:flutter_bloc/flutter_bloc.dart';

import 'recipe_event.dart';
import 'recipe_state.dart';

import '/domain/entities/recipe_model.dart';
import '/domain/use_cases/recipe/add_recipe.dart';
import '/domain/use_cases/recipe/close_service.dart';
import '/domain/use_cases/recipe/get_recipe.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final AddRecipeUseCase addRecipe;
  final CloseServiceUseCase closeService;
  final GetRecipesUseCase getRecipes;

  List<Recipe> recipes = [];

  RecipesBloc({
    required this.addRecipe,
    required this.closeService,
    required this.getRecipes,
  }) : super(RecipesInitial()) {
    on<LoadRecipesEvent>(
      (event, emit) async {
        emit(RecipesLoading());
        try {
          // Subscribe to the recipes stream
          await emit.forEach<List<Recipe>>(
            getRecipes.execute(),
            onData: (recipes) {
              this.recipes = recipes;
              return RecipesSuccess(recipes: recipes);
            },
            onError: (error, stackTrace) =>
                RecipesFailure(message: error.toString()),
          );
        } catch (e) {
          emit(
            RecipesFailure(
              message: 'Failed to load recipes.',
            ),
          );
        }
      },
    );

    on<AddRecipeEvent>(
      (event, emit) async {
        try {
          if (event.recipe.steps.isEmpty) {
            emit(
              RecipesFailure(
                message: 'Recipe steps cannot be empty.',
              ),
            );
          } else {
            await addRecipe(event.recipe);
            add(
              LoadRecipesEvent(),
            );
          }
        } catch (e) {
          emit(
            RecipesFailure(
              message: 'Failed to add recipe: ${e.toString()}.',
            ),
          );
        }
      },
    );

    on<CloseServiceEvent>(
      (event, emit) => closeService.execute(),
    );
  }
}
