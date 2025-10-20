import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String username, String password) async {
    try {
      setLoading();

      _currentUser = await _authRepository.login(username, password);

      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String password,
    required String email,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      setLoading();

      await _authRepository.register(
        username: username,
        password: password,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    try {
      setLoading();

      await _authRepository.logout();
      _currentUser = null;

      setIdle();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _authRepository.getCurrentUser();
      }
    } catch (e) {
      // Silent fail
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      setLoading();

      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
}
