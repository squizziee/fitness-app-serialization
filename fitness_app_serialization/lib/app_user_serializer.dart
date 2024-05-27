import 'package:flutter_fitness_app/models/training_regiment.dart';
import 'package:flutter_fitness_app/models/user.dart';

class AppUserSerializer {
  Map<String, dynamic> serialize(AppUser user) {
    var regimentList = [];
    for (var regiment in user.regiments!) {
      regimentList.add(regiment.id);
    }
    var goalList = [];
    for (var goal in user.goals!) {
      goalList.add(goal.id);
    }
    return {
      "user_uid": user.userUID,
      "regiments": regimentList,
      "goals": goalList
    };
  }

  // Handled by DatabaseService
  // Future<AppUser> deserealize(Map<String, dynamic> data) async {

  // }
}
