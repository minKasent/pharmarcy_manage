import 'package:flutter/foundation.dart';

enum ViewState {
  idle,
  loading,
  success,
  error,
}

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String _errorMessage = '';
  
  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;
  
  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
  
  void setError(String message) {
    _errorMessage = message;
    _state = ViewState.error;
    notifyListeners();
  }
  
  void setLoading() {
    _state = ViewState.loading;
    notifyListeners();
  }
  
  void setSuccess() {
    _state = ViewState.success;
    _errorMessage = '';
    notifyListeners();
  }
  
  void setIdle() {
    _state = ViewState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}