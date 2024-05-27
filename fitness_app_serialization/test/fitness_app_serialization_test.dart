import 'package:fitness_app_serialization/goal_firestore_serializer.dart';
import 'package:flutter_fitness_app/models/goal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Goal serialization test - simple objects', () {
    var serializer = GoalFirestoreSerializer();
    List<Goal>? goals = [
      Goal(
          deadline: DateTime(2024, 4, 1),
          exerciseName: "Barbell Bench Press",
          metrics: {
            GoalMetric(metricName: "repetitions", metricSize: 15),
          }),
      Goal(
          deadline: DateTime(2024, 4, 1),
          exerciseName: "Barbell Bench Press",
          metrics: {
            GoalMetric(metricName: "repetitions", metricSize: 15),
          }),
    ];
    expect(serializer.deserializeGoal(serializer.serializeGoal(goals[0])),
        goals[0]);
    expect(serializer.deserializeGoal(serializer.serializeGoal(goals[1])),
        goals[1]);
  });

  test('Goal serialization test - multiple metrics', () {
    var serializer = GoalFirestoreSerializer();
    List<Goal>? goals = [
      Goal(
          deadline: DateTime(2025, 4, 5),
          exerciseName: "Barbell Bench Press",
          metrics: {
            GoalMetric(metricName: "repetitions", metricSize: 15),
            GoalMetric(
                metricName: "weight", metricSize: 100, metricScale: "kg"),
            GoalMetric(
                metricName: "nuttin", metricSize: 1009, metricScale: "egor"),
            GoalMetric(
                metricName: "aboba", metricSize: 999, metricScale: "lms"),
            GoalMetric(
                metricName: "nadjhfsdb", metricSize: 999, metricScale: "lms")
          }),
      Goal(
          deadline: DateTime(1997, 4, 8),
          exerciseName: "Barbell Bench Press",
          metrics: {
            GoalMetric(metricName: "repetitions", metricSize: 15),
            GoalMetric(
                metricName: "weight", metricSize: 100, metricScale: "kg"),
            GoalMetric(
                metricName: "nuttin", metricSize: 1009, metricScale: "egor"),
            GoalMetric(metricName: "aboba", metricSize: 999, metricScale: "lms")
          }),
    ];
    expect(serializer.deserializeGoal(serializer.serializeGoal(goals[0])),
        goals[0]);
    expect(serializer.deserializeGoal(serializer.serializeGoal(goals[1])),
        goals[1]);
  });
}
