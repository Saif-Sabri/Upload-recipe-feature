import '/data/models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes();
  Future<void> saveRecipes(List<RecipeModel> recipeModel);
  Future<RecipeModel> removeRecipe(RecipeModel recipeModel);
}
