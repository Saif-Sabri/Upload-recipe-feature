import 'dart:convert';

import '../../domain/entities/recipe_model.dart';

class RecipeModel {
  final String id;
  final String name;
  final String? description;
  final List<StepInstructionModel> steps;
  final String? videoUrl;

  RecipeModel({
    required this.id,
    required this.name,
    this.description,
    required this.steps,
    required this.videoUrl,
  });

  // Convert JSON to RecipeModel
  factory RecipeModel.fromJson(Map<String, dynamic> recipeJson) {
    return RecipeModel(
      id: recipeJson['id'],
      name: recipeJson['name'],
      description: recipeJson['description'],
      steps: (recipeJson['steps'] as List)
          .map(
            (step) => StepInstructionModel.fromJson(step),
          )
          .toList(),
      videoUrl: recipeJson['videoUrl'],
    );
  }

  // Convert RecipeModel to JSON
  static Map<String, dynamic> toJson(RecipeModel recipeModel) {
    return {
      'id': recipeModel.id,
      'name': recipeModel.name,
      'description': recipeModel.description,
      'steps': recipeModel.steps
          .map(
            (step) => StepInstructionModel.toJson(step),
          )
          .toList(),
      'videoUrl': recipeModel.videoUrl,
    };
  }

  // Convert RecipeModel to Recipe
  Recipe toEntity() {
    return Recipe(
      id: id,
      name: name,
      description: description,
      steps: steps
          .map(
            (step) => step.toEntity(),
          )
          .toList(),
      videoUrl: videoUrl,
    );
  }
}

class StepInstructionModel {
  final String? id;
  final String name;
  final int beginTime;
  final int endTime;
  String instruction;

  StepInstructionModel({
    this.id,
    required this.name,
    required this.beginTime,
    required this.endTime,
    required this.instruction,
  });

  // Convert JSON to StepInstruction
  factory StepInstructionModel.fromJson(Map<String, dynamic> json) {
    return StepInstructionModel(
      id: json['id'],
      name: json['name'],
      beginTime: json['beginTime'],
      endTime: json['endTime'],
      instruction: json['instruction'],
    );
  }

  // Convert StepInstruction to JSON
  static Map<String, dynamic> toJson(StepInstructionModel recipeModel) {
    return {
      'id': recipeModel.id,
      'name': recipeModel.name,
      'beginTime': recipeModel.beginTime,
      'endTime': recipeModel.endTime,
      'instruction': recipeModel.instruction,
    };
  }

  // Convert StepInstruction to StepInstructionModel
  StepInstruction toEntity() {
    return StepInstruction(
      id: id,
      name: name,
      beginTime: beginTime,
      endTime: endTime,
      instruction: instruction,
    );
  }
}
