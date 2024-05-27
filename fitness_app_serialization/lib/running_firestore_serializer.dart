import 'package:fitness_app_serialization/firestore_serializer.dart';
import 'package:flutter_fitness_app/models/exercise.dart';
import 'package:flutter_fitness_app/models/running/running_exercise.dart';
import 'package:flutter_fitness_app/models/running/running_exercise_type.dart';
import 'package:flutter_fitness_app/models/running/running_session.dart';
import 'package:flutter_fitness_app/models/training_session.dart';

class RunningFirestoreSerializer extends FirestoreSerializer {
  @override
  Map<String, Object?> serializeSession(TrainingSession session) {
    var session_ = session as RunningSession;
    var exerciseList = [];
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
      exerciseList.add(RunningExercise(
          notes: exercise["notes"],
          exerciseType: RunningExerciseType(
              name: type["name"], iconURL: type["icon_url"]),
          heartbeatCeiling: exercise["heartbeat_ceiling"],
          distanceInMeters: exercise["distance_in_meters"]));
    }

    return RunningSession(
        id: ref,
        name: data["name"],
        notes: data["notes"],
        exercises: exerciseList,
        dayInSchedule: dayInSchedule);
  }
}
