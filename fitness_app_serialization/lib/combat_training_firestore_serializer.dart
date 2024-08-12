import 'package:fitness_app_serialization/firestore_serializer.dart';
import 'package:flutter_fitness_app/models/combat_training/combat_training_exercise.dart';
import 'package:flutter_fitness_app/models/combat_training/combat_training_exercise_type.dart';
import 'package:flutter_fitness_app/models/combat_training/combat_training_session.dart';
import 'package:flutter_fitness_app/models/base/exercise.dart';
import 'package:flutter_fitness_app/models/base/training_session.dart';

class CombatTrainingFirestoreSerializer extends FirestoreSerializer {
  @override
  Map<String, Object?> serializeSession(TrainingSession session) {
    var session_ = session as CombatTrainingSession;
    var exerciseList = [];
    // ignore: unused_local_variable
    for (var exercise in session_.exercises) {
      exerciseList.add({"exercise_id": null});
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
      // Get exercise type
      var type = (await exercise["exercise_id"].get()).data()!;
      exerciseList.add(CombatTrainingExercise(
          notes: exercise["notes"],
          exerciseType: CombatTrainingExerciseType(
              style: exercise["style"],
              name: type["name"],
              iconURL: type["icon_url"]),
          heartbeatCeiling: exercise["heartbeat_ceiling"],
          time: exercise["time"]));
    }

    return CombatTrainingSession(
        id: ref,
        name: data["name"],
        notes: data["notes"],
        exercises: exerciseList,
        dayInSchedule: dayInSchedule);
  }
}
