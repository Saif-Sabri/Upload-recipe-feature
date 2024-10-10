import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '/core/exceptions/service_exception.dart';

import '/data/models/recipe_model.dart';
import '/data/datasources/recipe_remote_data_source.dart';

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final SharedPreferences sharedPreferences;
  RecipeRemoteDataSourceImpl({
    required this.sharedPreferences,
  });

  final String _recipesKey = 'saved_recipes';

  @override
  Future<List<RecipeModel>> getRecipes() async {
    try {
      /// Initialize the key if it doesn't exist
      if (!sharedPreferences.containsKey(_recipesKey)) {
        await sharedPreferences.setStringList(
          _recipesKey,
          [],
        );
      }
      final List<String>? savedRecipesJson =
          sharedPreferences.getStringList(_recipesKey);
      return savedRecipesJson!
          .map(
            (recipeJson) => RecipeModel.fromJson(
              json.decode(recipeJson),
            ),
          )
          .toList();
    } catch (e) {
      throw ServiceException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> saveRecipes(List<RecipeModel> recipesModel) async {
    try {
      await sharedPreferences.setStringList(
        _recipesKey,
        recipesModel
            .map(
              (recipeModel) => json.encode(
                RecipeModel.toJson(recipeModel),
              ),
            )
            .toList(),
      );
    } catch (e) {
      throw ServiceException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<RecipeModel> removeRecipe(RecipeModel recipeModel) {
    // TODO: implement removeRecipe
    throw UnimplementedError();
  }
}
