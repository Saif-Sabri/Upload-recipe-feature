import 'package:dartz/dartz.dart';

import '/core/exceptions/service_failure.dart';
import '/domain/entities/recipe_model.dart';

abstract class RecipeRepository {
  Stream<List<Recipe>> getRecipesStream();
  void closeService();
  Future<Either<Failure, int>> addRecipe(Recipe recipe);
  Future<Either<Failure, Recipe>> removeRecipe(Recipe recipe);
  Future<Either<Failure, Recipe>> addRecipeSteps(Recipe recipe);
}
