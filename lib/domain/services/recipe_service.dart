import 'package:rxdart/rxdart.dart';

import '/data/datasources/recipe_remote_data_source.dart';
import '/data/models/recipe_model.dart';

import '/domain/entities/recipe_model.dart';

class RecipeService {
  final RecipeRemoteDataSource remoteDataSource;

  /// Reactive stream for recipes
  final _recipesSubject = BehaviorSubject<List<Recipe>>.seeded([]);
  Stream<List<Recipe>> get recipesStream => _recipesSubject.stream;

  RecipeService({required this.remoteDataSource}) {
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final List<RecipeModel> savedRecipesModel =
          await remoteDataSource.getRecipes();
      final List<Recipe> savedRecipes = savedRecipesModel
          .map(
            (recipeModel) => recipeModel.toEntity(),
          )
          .toList();
      if (savedRecipes.isNotEmpty) {
        _recipesSubject.add(savedRecipes);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    final List<Recipe> currentRecipes = _recipesSubject.value;

    currentRecipes.add(
      recipe,
    );

    await remoteDataSource.saveRecipes(
      currentRecipes
          .map(
            (recipe) => recipe.toModel(),
          )
          .toList(),
    );

    _recipesSubject.add(
      currentRecipes,
    );
  }

  /// TODO: Implement remove recipe methods
  // Future<void> removeRecipe(Recipe recipe) async {
  //   final List<Recipe> currentRecipes = _recipesSubject.value;

  //   currentRecipes.remove(
  //     recipe,
  //   );

  //   await prefs.setStringList(
  //     _recipesKey,
  //     currentRecipes,
  //   );
  //   _recipesSubject.add(
  //     currentRecipes,
  //   );
  // }

  // Future<void> clearRecipes() async {
  //   await prefs.remove(
  //     _recipesKey,
  //   );
  //   _recipesSubject.add(
  //     [],
  //   );
  // }

  void dispose() {
    _recipesSubject.close();
  }
}
