import 'package:fitness_app_serialization/firebase_serializer.dart';
import 'package:flutter_fitness_app/models/exercise.dart';
import 'package:flutter_fitness_app/models/training_session.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_exercise_type.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_training_exercise.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_training_session.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_training_set.dart';
import 'package:flutter_fitness_app/services/database_service.dart';

class WeightTrainingFirestoreSerializer extends FirebaseSerializer {
  final DatabaseService _dbService = DatabaseService();

  @override
  Map<String, Object?> serializeSession(TrainingSession session) {
    var session_ = session as WeightTrainingSession;
    var exerciseList = [];
    for (var exercise in session_.exercises) {
      var exercise_ = exercise as WeightTrainingExercise;
      var sets = [];
      for (var set_ in exercise_.sets) {
        sets.add({
          "notes": set_.notes,
          "repetitions": set_.repetitions,
          "set_index": set_.setIndex,
          "weight": set_.weightInKilograms
        });
      }
      exerciseList.add({"Sets": sets, "exercise_id": exercise.id});
    }
    var serialized = {
      "name": session_.name,
      "notes": session_.notes,
      "exercises": exerciseList
    };
    return serialized;
  }

  @override
  Future<TrainingSession> deserializeSession(
      data, int dayInSchedule, String id) async {
    List<Exercise> exerciseList = [];

    // Iterate through all exercises in data snapshot
    for (var exercise in data["exercises"]) {
      List<WeightTrainingSet> sets = [];

      // Iterate through all sets in exercise
      for (var set_ in exercise.sets) {
        sets.add(WeightTrainingSet(
            weightInKilograms: set_["weight"],
            repetitions: set_["repetitions"],
            notes: set_["notes"],
            setIndex: set_["set_index"]));
      }

      // Get exercise type
      var type =
          (await _dbService.getExerciseTypeByID(exercise.exercise_id)).data()!;
      exerciseList.add(WeightTrainingExercise(
          sets: sets,
          notes: exercise["notes"],
          id: exercise["exercise_id"],
          exerciseType: WeightExerciseType(
              name: type["name"],
              bodyPart: type["bodypart"],
              iconURL: type["icon_url"],
              category: type["category"])));
    }
    return WeightTrainingSession(
        id: id,
        name: data["name"],
        notes: data["notes"],
        exercises: exerciseList,
        dayInSchedule: dayInSchedule);
  }
}
