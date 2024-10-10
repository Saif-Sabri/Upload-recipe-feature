import '/domain/entities/recipe_model.dart';
import '/domain/repositories/recipe_repository.dart';

class GetRecipesUseCase {
  final RecipeRepository _recipeRepository;

  GetRecipesUseCase(
    this._recipeRepository,
  );

  Stream<List<Recipe>> execute() {
    return _recipeRepository.getRecipesStream();
  }
}
