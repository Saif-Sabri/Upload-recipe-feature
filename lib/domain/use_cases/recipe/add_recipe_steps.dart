import 'package:dartz/dartz.dart';

import '/core/exceptions/service_failure.dart';
import '/domain/entities/recipe_model.dart';
import '/domain/repositories/recipe_repository.dart';

class AddRecipeStepsUseCase {
  final RecipeRepository _recipeRepository;

  AddRecipeStepsUseCase(this._recipeRepository);

  Future<Either<Failure, Recipe>> call(Recipe recipe) {
    return _recipeRepository.addRecipeSteps(recipe);
  }
}
