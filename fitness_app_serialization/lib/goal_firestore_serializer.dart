import 'package:flutter_fitness_app/models/goal.dart';

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
      "exercise_id": goal.exerciseName,
      "metrics": metrics
    };
  }

  Goal deserializeGoal(data) {
    Set<GoalMetric> metrics = {};
    for (var metric in data["metrics"]) {
      metrics.add(GoalMetric(
        metricName: metric["metric_name"],
        metricSize: metric["metric_size"],
        metricScale: metric["metric_scale"],
      ));
    }
    return Goal(
        deadline: data["deadline"],
        exerciseName: data["exercise_id"],
        metrics: metrics);
  }
}
