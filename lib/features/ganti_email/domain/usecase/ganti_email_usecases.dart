import 'package:hr_attendance/features/ganti_email/data/models/email_model.dart';
import 'package:hr_attendance/features/ganti_email/domain/repositories/email_repositories.dart';

class GantiEmailUsecases {
  final EmailRepository repository;

  GantiEmailUsecases(this.repository);

  Future<void> call(EmailModel model) {
    return repository.changeEmail(model);
  }
}