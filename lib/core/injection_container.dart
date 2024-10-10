import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/data/datasources/recipe_remote_data_source.dart';
import '/data/datasources/remote/recipe_remote_data_source_impl.dart';
import '/data/repositories/recipe_repository_impl.dart';
import '/data/repositories/video_repository_impl.dart';

import '/domain/repositories/recipe_repository.dart';
import '/domain/repositories/video_repository.dart';
import '/domain/services/recipe_service.dart';
import '/domain/use_cases/recipe/add_recipe.dart';
import '/domain/use_cases/recipe/add_recipe_steps.dart';
import '/domain/use_cases/recipe/close_service.dart';
import '/domain/use_cases/recipe/get_recipe.dart';
import '/domain/use_cases/video/upload_video.dart';

import '/presentation/bloc/recipe/recipe_bloc.dart';
import '/presentation/bloc/recipe_steps/recipe_steps_bloc.dart';
import '/presentation/bloc/video/video_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Bloc
  getIt.registerFactory(
    () => RecipesBloc(
      addRecipe: getIt(),
      closeService: getIt(),
      getRecipes: getIt(),
    ),
  );
  getIt.registerFactory(
    () => RecipeStepsBloc(
      addRecipeSteps: getIt(),
    ),
  );
  getIt.registerFactory(
    () => VideoBloc(
      uploadVideo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => UploadVideoUseCase(
      getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => AddRecipeUseCase(
      getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => AddRecipeStepsUseCase(
      getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetRecipesUseCase(
      getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => CloseServiceUseCase(
      getIt(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(),
  );
  getIt.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(
      remoteDataSource: getIt(),
      recipeService: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(
      sharedPreferences: getIt(),
    ),
  );

  // Local services
  getIt.registerLazySingleton(
    () => RecipeService(
      remoteDataSource: getIt(),
    ),
  );

  // Remote services
  // getIt.registerLazySingleton(
  //   () => http.Client(),
  // );

  // External
  getIt.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  await GetIt.instance.isReady<SharedPreferences>();
}
