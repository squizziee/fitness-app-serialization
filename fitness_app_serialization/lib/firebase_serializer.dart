import 'package:flutter_fitness_app/models/training_regiment.dart';
import 'package:flutter_fitness_app/models/training_session.dart';
import 'package:flutter_fitness_app/services/database_service.dart';

abstract class FirebaseSerializer {
  Future<TrainingRegiment> deserializeRegiment(data, String id) async {
    final DatabaseService _dbService = DatabaseService();
    List<TrainingSession> schedule = [];
    var count = 0;
    for (var sessionRef in data.schedule) {
      schedule.add(await deserializeSession(sessionRef, count++, sessionRef));
    }
    return TrainingRegiment(
        name: data["name"],
        id: id,
        notes: data["notes"],
        trainingType: _dbService.getTrainingType(data["training_type"]),
        schedule: schedule,
        startDate: data["start_date"],
        cycleDurationInDays: schedule.length);
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
      "start_date": regiment.startDate
    };
    return serialized;
  }

  Map<String, Object?> serializeSession(TrainingSession session);
  Future<TrainingSession> deserializeSession(
      data, int dayInSchedule, String id);
}