import 'package:hr_attendance/features/ganti_email/data/datasource/email_remote_datasource.dart';
import 'package:hr_attendance/features/ganti_email/data/models/email_model.dart';
import 'package:hr_attendance/features/ganti_email/domain/repositories/email_repositories.dart';

class EmailRepositoryImpl implements EmailRepository {
  final EmailRemoteDatasource remoteDatasource;

  EmailRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> changeEmail(EmailModel model) {
    return remoteDatasource.changeEmail(model);
  }
}