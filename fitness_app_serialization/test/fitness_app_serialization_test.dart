import 'package:fitness_app_serialization/goal_firestore_serializer.dart';
import 'package:flutter_fitness_app/models/goal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Goal serialization test', () {
    var serializer = GoalFirestoreSerializer();
    List<Goal>? goals = [
      Goal(
          deadline: DateTime(2024, 4, 1),
          exerciseName: "Barbell Bench Press",
          metrics: {
            GoalMetric(metricName: "repetitions", metricSize: 15),
            GoalMetric(metricName: "weight", metricSize: 100, metricScale: "kg")
          }),
      Goal(
          deadline: DateTime(2024, 4, 1),
          exerciseName: "Barbell Bench Press",
          metrics: {
            GoalMetric(metricName: "repetitions", metricSize: 15),
            GoalMetric(metricName: "weight", metricSize: 100, metricScale: "kg")
          }),
      Goal(
          deadline: DateTime(2024, 7, 1),
          exerciseName: "Barbell Bench Press",
          metrics: {
            GoalMetric(metricName: "repetitions", metricSize: 12),
            GoalMetric(metricName: "weight", metricSize: 105, metricScale: "kg")
          }),
      Goal(
          deadline: DateTime(2024, 8, 1),
          exerciseName: "Barbell Squat",
          metrics: {
            GoalMetric(metricName: "repetitions", metricSize: 5),
            GoalMetric(metricName: "weight", metricSize: 180, metricScale: "kg")
          })
    ];
    expect(serializer.deserializeGoal(serializer.serializeGoal(goals[0])),
        goals[0]);
    expect(serializer.deserializeGoal(serializer.serializeGoal(goals[1])),
        goals[1]);
    expect(serializer.deserializeGoal(serializer.serializeGoal(goals[2])),
        goals[2]);
    expect(serializer.deserializeGoal(serializer.serializeGoal(goals[3])),
        goals[3]);
  });
}
