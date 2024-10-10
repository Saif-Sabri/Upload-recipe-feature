import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/injection_container.dart';

import '/presentation/bloc/recipe/recipe_bloc.dart';
import '/presentation/bloc/recipe/recipe_event.dart';
import '/presentation/bloc/recipe/recipe_state.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  void dispose() {
    context.read<RecipesBloc>().add(CloseServiceEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'All recipes',
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                context.push(
                  '/add-recipe',
                );
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: BlocProvider(
                create: (context) => getIt<RecipesBloc>()
                  ..add(
                    LoadRecipesEvent(),
                  ),
                child: BlocConsumer<RecipesBloc, RecipesState>(
                  listener: (context, state) {
                    if (state is RecipesFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is RecipesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is RecipesSuccess) {
                      final recipes = state.recipes;

                      if (recipes.isEmpty) {
                        return const Center(
                          child: Text(
                            'No recipes saved.',
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];

                            return Card(
                              child: ListTile(
                                title: Text(
                                  recipe.name,
                                ),
                                leading: IconButton(
                                    onPressed: () {
                                      context.push(
                                        '/view-recipe',
                                        extra: recipe,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.open_in_new,
                                    )),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  onPressed: () {
                                    // Implement deletion logic here if needed
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is RecipesFailure) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                        ),
                      );
                    }

                    return const Center(
                      child: Text(
                        'Unknown state.',
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
