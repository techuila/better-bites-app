import 'package:betterbitees/models/profiling.dart';
import 'package:betterbitees/repositories/profiling_repo.dart';

class ProfilingService {
  final ProfilingRepo profilingRepo;

  ProfilingService({required this.profilingRepo});

  // Save profile data
  Future<void> saveProfile ({
    required String age,
    required String gender,
    required String height,
    required String weight,
    required String healthCondition,
  }) async {
    final profiling = Profiling(id: -1, age: age, gender: gender, height: height, weight: weight, healthCondition: healthCondition);

    await profilingRepo.upsert(profiling);
  }

  // Update profile field
  Future<void> updateProfile(Profiling profiling) async {
    await profilingRepo.upsert(profiling);
  }

  // Get profile data
  Future<Profiling?> getProfile() async {
    return await profilingRepo.get();
  }
}
