import 'package:hr_attendance/features/ganti_password/data/models/password_model.dart';

abstract class PasswordRepositories {
  PasswordRepositories(find);

  Future<void> submitPassword(PasswordModel request);
}