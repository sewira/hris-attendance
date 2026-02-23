import 'package:hr_attendance/features/pengajuan_cuti/data/models/cuti_model.dart';

abstract class CutiRepository {
  Future<void> submitCuti(CutiModel request);
}