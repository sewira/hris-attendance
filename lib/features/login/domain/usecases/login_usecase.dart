import '../repositories/login_repository.dart';
import '../../data/models/user_model.dart';

class LoginUsecase {
  final LoginRepository repository;

  LoginUsecase(this.repository);

  Future<UserModel> call(String email, String password) {
    return repository.login(email, password);
  }
}
