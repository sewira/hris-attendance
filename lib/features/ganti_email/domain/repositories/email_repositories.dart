import 'package:hr_attendance/features/ganti_email/data/models/email_model.dart';

abstract class EmailRepository {
  Future<void> changeEmail(EmailModel model);
}