import 'package:flutter_fitness_app/models/base/training_regiment.dart';
import 'package:flutter_fitness_app/models/base/training_session.dart';
import 'package:flutter_fitness_app/services/database_service.dart';

abstract class FirestoreSerializer {
  final DatabaseService _dbService = DatabaseService();
  Future<TrainingRegiment> deserializeRegiment(data, ref) async {
    List<TrainingSession> schedule = [];
    var count = 0;
    for (var sessionRef in data["schedule"]) {
      schedule.add(await deserializeSession(
          (await sessionRef.get()).data()!, count++, sessionRef));
    }
    return TrainingRegiment(
        name: data["name"],
        id: ref,
        notes: data["notes"],
        trainingType: _dbService.getTrainingType(data["training_type"]),
        schedule: schedule,
        startDate: data["start_date"],
        cycleDurationInDays: schedule.length,
        dayOfPause: data["day_of_pause"]);
  }

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

  Map<String, Object?> serializeSession(TrainingSession session);
  Future<TrainingSession> deserializeSession(data, int dayInSchedule, ref);
}
