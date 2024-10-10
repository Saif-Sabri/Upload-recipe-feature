import 'package:dartz/dartz.dart';

import '/core/exceptions/service_failure.dart';
import '/domain/entities/recipe_model.dart';
import '/domain/repositories/recipe_repository.dart';

class AddRecipeUseCase {
  final RecipeRepository _recipeRepository;

  AddRecipeUseCase(this._recipeRepository);

  Future<Either<Failure, int>> call(Recipe recipe) {
    return _recipeRepository.addRecipe(recipe);
  }
}
