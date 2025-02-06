import 'package:betterbitees/helpers/db.dart';
import 'package:betterbitees/models/profiling.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class ProfilingRepo {
  // Get profile data and if empty, return null
  Future<Profiling?> get() async {
    final db = await DBHelper.open();
    final result = await db.query('profiling');


    // check if result has values
    if (result.isNotEmpty) {
      return Profiling.toJson(result[0]);
    }

    return null;
  }

  Future<int> upsert(Profiling profile) async {
    final db = await DBHelper.open();
    Batch batch = db.batch();
    int profileId = -1;

    // Create profile
    if (profile.id == -1) {
      debugPrint('Creating profile: $profile');
      final profileId = await db.insert('profiling', {
        'age': profile.age,
        'gender': profile.gender,
        'height': profile.height,
        'weight': profile.weight,
        'health_condition': profile.healthCondition
      });
    } else {
      debugPrint('Updating profile: $profile');
      profileId = profile.id!;
      final result = await db.update('profiling', {
        'age': profile.age,
        'gender': profile.gender,
        'height': profile.height,
        'weight': profile.weight,
        'health_condition': profile.healthCondition
      },
      where: 'id = ?',
      whereArgs: [profile.id]);
    }

    await batch.commit(noResult: true);

    return profileId;
  }
}
