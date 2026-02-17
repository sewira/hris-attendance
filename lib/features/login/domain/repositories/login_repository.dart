import '../../data/models/user_model.dart';

abstract class LoginRepository {
  Future<UserModel> login(String email, String password);
}
