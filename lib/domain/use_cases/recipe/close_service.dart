import '/domain/repositories/recipe_repository.dart';

class CloseServiceUseCase {
  final RecipeRepository _recipeRepository;

  CloseServiceUseCase(
    this._recipeRepository,
  );

  void execute() {
    return _recipeRepository.closeService();
  }
}
