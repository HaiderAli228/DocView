import 'package:flutter/foundation.dart';

import '../model/dept_model.dart';
import '../model/dept_repo.dart';


class HomeViewModel extends ChangeNotifier {
  final DepartmentRepository _repository = DepartmentRepository();
  List<Department> _departments = [];
  bool _isLoading = false;

  List<Department> get departments => _departments;
  bool get isLoading => _isLoading;

  Future<void> fetchDepartments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _departments = await _repository.fetchDepartments();
    } catch (e) {
      _departments = [];
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
