import 'package:fitness_app_serialization/firestore_serializer.dart';
import 'package:flutter_fitness_app/models/base/exercise.dart';
import 'package:flutter_fitness_app/models/swimming/swimming_exercise.dart';
import 'package:flutter_fitness_app/models/swimming/swimming_exercise_type.dart';
import 'package:flutter_fitness_app/models/swimming/swimming_session.dart';
import 'package:flutter_fitness_app/models/swimming/swimming_set.dart';
import 'package:flutter_fitness_app/models/base/training_session.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_training_session.dart';

class SwimmingFirestoreSerializer extends FirestoreSerializer {
  @override
  Map<String, Object?> serializeSession(TrainingSession session) {
    var session_ = session as WeightTrainingSession;
    var exerciseList = [];
    for (var exercise in session_.exercises) {
      var exercise_ = exercise as SwimmingExercise;
      var sets = [];
      for (var set_ in exercise_.sets) {
        sets.add({
          "notes": set_.notes,
          "repetitions": set_.repetitions,
          "set_index": set_.setIndex,
          "distance_in_meters": set_.distanceInMeters,
          "is_preset": set_.isPreset,
          "is_underwaters": set_.isUnderwaters,
          "time": set_.time
        });
      }
      exerciseList.add({"Sets": sets, "exercise_id": null});
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
      data, int dayInSchedule, ref) async {
    List<Exercise> exerciseList = [];
    // Iterate through all exercises in data snapshot
    for (var exercise in data["exercises"]) {
      List<SwimmingSet> sets = [];

      // Iterate through all sets in exercise
      for (var set_ in exercise["Sets"]) {
        sets.add(SwimmingSet(
            isPreset: set_["is_preset"],
            isUnderwaters: set_["is_underwaters"],
            distanceInMeters: set_["distance_in_meters"],
            repetitions: set_["repetitions"],
            notes: set_["notes"],
            time: set_["time"],
            setIndex: set_["set_index"]));
      }

      // Get exercise type
      var type = (await exercise["exercise_id"].get()).data()!;
      exerciseList.add(SwimmingExercise(
          sets: sets,
          notes: exercise["notes"],
          exerciseType: SwimmingExerciseType(
              name: type["name"], iconURL: type["icon_url"])));
    }

    return SwimmingSession(
        id: ref,
        name: data["name"],
        notes: data["notes"],
        exercises: exerciseList,
        dayInSchedule: dayInSchedule);
  }
}
