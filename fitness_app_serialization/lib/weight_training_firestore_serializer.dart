import 'package:fitness_app_serialization/firestore_serializer.dart';
import 'package:flutter_fitness_app/models/exercise.dart';
import 'package:flutter_fitness_app/models/training_regiment.dart';
import 'package:flutter_fitness_app/models/training_session.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_exercise_type.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_training_exercise.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_training_session.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_training_set.dart';
import 'package:flutter_fitness_app/services/database_service.dart';

class WeightTrainingFirestoreSerializer extends FirestoreSerializer {
  final DatabaseService _dbService = DatabaseService();

  // TODO deserealize goals too
  @override
  Future<TrainingRegiment> deserializeRegiment(data, ref) async {
    List<TrainingSession> schedule = [];
    var count = 0;
    for (var sessionRef in data["schedule"]) {
      if (sessionRef == null) {
        schedule.add(WeightTrainingSession(
            id: null,
            name: '',
            notes: '',
            exercises: [],
            dayInSchedule: count++));
      } else {
        schedule.add(await deserializeSession(
            (await sessionRef.get()).data()!, count++, sessionRef));
      }
    }
    return TrainingRegiment(
        name: data["name"],
        id: ref,
        notes: data["notes"],
        trainingType: _dbService.getTrainingType(data["training_type"]),
        schedule: schedule,
        startDate:
            data["start_date"] == null ? null : data["start_date"].toDate(),
        cycleDurationInDays: schedule.length,
        dayOfPause: data["day_of_pause"]);
  }

  @override
  Map<String, Object?> serializeRegiment(TrainingRegiment regiment) {
    var sessionIdList = [];
    for (var session in regiment.schedule!) {
      sessionIdList.add(session.id);
    }
    var serialized = {
      "name": regiment.name,
      "notes": regiment.notes,
      "training_type": regiment.trainingType.toString(),
      "schedule": sessionIdList,
      "start_date": regiment.startDate,
      "day_of_pause": regiment.dayOfPause
    };
    return serialized;
  }

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
      exerciseList
          .add({"Sets": sets, "exercise_id": exercise_.exerciseType!.id});
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
      List<WeightTrainingSet> sets = [];

      // Iterate through all sets in exercise
      for (var set_ in exercise["Sets"]) {
        sets.add(WeightTrainingSet(
            weightInKilograms: set_["weight"],
            repetitions: set_["repetitions"],
            notes: set_["notes"],
            setIndex: set_["set_index"]));
      }

      // Get exercise type
      var type = (await exercise["exercise_id"].get()).data()!;
      exerciseList.add(WeightTrainingExercise(
          sets: sets,
          exerciseType: WeightExerciseType(
              id: exercise["exercise_id"],
              name: type["name"],
              bodyPart: type["bodypart"],
              iconURL: type["icon_url"],
              category: type["category"])));
    }

    return WeightTrainingSession(
        id: ref,
        name: data["name"],
        notes: data["notes"],
        exercises: exerciseList,
        dayInSchedule: dayInSchedule);
  }

  Future<TrainingSession> deserializeSessionNew(
      data, int dayInSchedule, ref) async {
    List<Exercise> exerciseList = [];
    // Iterate through all exercises in data snapshot
    for (var exercise in data["exercises"]) {
      List<WeightTrainingSet> sets = [];

      // Iterate through all sets in exercise
      for (var set_ in exercise["Sets"]) {
        sets.add(WeightTrainingSet(
            weightInKilograms: set_["weight"],
            repetitions: set_["repetitions"],
            notes: set_["notes"],
            setIndex: set_["set_index"]));
      }

      // Get exercise type
      var type = (await exercise["exercise_id"].get()).data()!;
      exerciseList.add(WeightTrainingExercise(
          sets: sets,
          notes: exercise["notes"],
          exerciseType: WeightExerciseType(
              id: exercise["exercise_id"],
              name: type["name"],
              bodyPart: type["bodypart"],
              iconURL: type["icon_url"],
              category: type["category"])));
    }

    return WeightTrainingSession(
        id: ref,
        name: data["name"],
        notes: data["notes"],
        exercises: exerciseList,
        dayInSchedule: dayInSchedule);
  }
}
