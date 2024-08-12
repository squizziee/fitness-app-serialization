import 'package:flutter_fitness_app/models/base/goal.dart';
import 'package:flutter_fitness_app/models/weight_training/weight_exercise_type.dart';

class GoalFirestoreSerializer {
  Map<String, dynamic> serializeGoal(Goal goal) {
    var metrics = [];
    for (var metric in goal.metrics!) {
      metrics.add({
        "metric_name": metric.metricName,
        "metric_size": metric.metricSize,
        "metric_scale": metric.metricScale,
      });
    }
    return {
      "deadline": goal.deadline,
      "exercise_id": goal.exerciseType!.id,
      "metrics": metrics,
      "notification_id": goal.notificationId
    };
  }

  Future<Goal> deserializeGoal(data, ref) async {
    Set<GoalMetric> metrics = {};
    for (var metric in data["metrics"]) {
      metrics.add(GoalMetric(
        metricName: metric["metric_name"],
        metricSize: metric["metric_size"].toDouble(),
        metricScale: metric["metric_scale"],
      ));
    }
    var type = (await data["exercise_id"].get()).data()!;
    return Goal(
        deadline: data["deadline"].toDate(),
        exerciseType: WeightExerciseType(
            id: data["exercise_id"],
            name: type["name"],
            bodyPart: type["bodypart"],
            iconURL: type["icon_url"],
            category: type["category"]),
        id: ref,
        notificationId: data["notification_id"],
        metrics: metrics);
  }
}
