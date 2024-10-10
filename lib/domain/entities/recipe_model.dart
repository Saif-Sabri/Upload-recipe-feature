import 'package:equatable/equatable.dart';

import '/data/models/recipe_model.dart';

class Recipe extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<StepInstruction> steps;
  String? videoUrl;

  Recipe({
    required this.id,
    required this.name,
    this.description,
    required this.steps,
    required this.videoUrl,
  });

  RecipeModel toModel() {
    return RecipeModel(
      id: id,
      name: name,
      description: description,
      steps: steps
          .map(
            (step) => step.toModel(),
          )
          .toList(),
      videoUrl: videoUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
      ];
}

class StepInstruction {
  final String? id;
  final String name;
  final int beginTime;
  final int endTime;
  String instruction;

  StepInstruction({
    this.id,
    required this.name,
    required this.beginTime,
    required this.endTime,
    required this.instruction,
  });

  StepInstructionModel toModel() {
    return StepInstructionModel(
      id: id,
      name: name,
      beginTime: beginTime,
      endTime: endTime,
      instruction: instruction,
    );
  }
}

class Ingredient {
  final String name;
  final String quantity;

  const Ingredient({
    required this.name,
    required this.quantity,
  });
}
