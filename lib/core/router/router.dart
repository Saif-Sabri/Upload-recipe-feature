import 'package:go_router/go_router.dart';

import '/domain/entities/recipe_model.dart';

import '/presentation/pages/recipe/view_recipe.dart';
import '/presentation/pages/recipe_uploader/recipe_uploader.dart';
import '/presentation/pages/recipes_list/recipes_list.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      name: 'all-recipes',
      path: '/',
      builder: (context, state) => const RecipesPage(),
    ),
    GoRoute(
      name: 'add-recipe',
      path: '/add-recipe',
      builder: (context, state) => const RecipeUploader(),
    ),
    GoRoute(
      name: 'view-recipe',
      path: '/view-recipe',
      builder: (context, state) {
        final recipe = state.extra as Recipe;
        return ViewRecipe(
          recipe: recipe,
        );
      },
    ),
  ],
  routerNeglect: true,
  debugLogDiagnostics: true,
);
