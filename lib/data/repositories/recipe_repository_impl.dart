import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import '/data/datasources/recipe_remote_data_source.dart';
import '/data/models/recipe_model.dart';

import '/core/exceptions/service_exception.dart';
import '/core/exceptions/service_failure.dart';

import '/domain/entities/recipe_model.dart';
import '/domain/repositories/recipe_repository.dart';
import '/domain/services/recipe_service.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeService recipeService;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.recipeService,
  });

  @override
  Stream<List<Recipe>> getRecipesStream() {
    return recipeService.recipesStream;
  }

  @override
  void closeService() {
    recipeService.dispose();
  }

  @override
  Future<Either<Failure, int>> addRecipe(Recipe recipe) async {
    try {
      await recipeService.addRecipe(recipe);
      return const Right(1);
    } catch (e) {
      return Left(
        ServiceFailure(
          message: 'Failed to add recipe.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Recipe>> removeRecipe(Recipe recipe) {
    // TODO: implement removeRecipe
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Recipe>> addRecipeSteps(Recipe recipe) async {
    if (recipe.steps.isEmpty) {
      return Left(
        ServiceFailure(
          message: 'The recipe must have at least one step.',
        ),
      );
    } else {
      return Right(
        recipe,
      );
    }
  }
}
