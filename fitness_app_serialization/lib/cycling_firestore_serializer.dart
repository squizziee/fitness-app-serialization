import 'package:fitness_app_serialization/firestore_serializer.dart';
import 'package:flutter_fitness_app/models/cycling/cycling_exercise.dart';
import 'package:flutter_fitness_app/models/cycling/cycling_exercise_type.dart';
import 'package:flutter_fitness_app/models/cycling/cycling_session.dart';
import 'package:flutter_fitness_app/models/base/exercise.dart';
import 'package:flutter_fitness_app/models/base/training_session.dart';

// TODO all this does not work because I fucked up references, so I placed null as ref
class CyclingFirestoreSerializer extends FirestoreSerializer {
  @override
  Map<String, Object?> serializeSession(TrainingSession session) {
    var session_ = session as CyclingSession;
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
      exerciseList.add(CyclingExercise(
          notes: exercise["notes"],
          exerciseType: CyclingExerciseType(
              name: type["name"], iconURL: type["icon_url"]),
          distanceInMeters: exercise["distance_in_meters"],
          heartbeatCeiling: exercise["heartbeat_ceiling"],
          time: exercise["time"]));
    }

    return CyclingSession(
        id: ref,
        name: data["name"],
        notes: data["notes"],
        exercises: exerciseList,
        dayInSchedule: dayInSchedule);
  }
}
