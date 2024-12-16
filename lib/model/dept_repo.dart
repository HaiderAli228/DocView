import 'package:cloud_firestore/cloud_firestore.dart';

import 'dept_model.dart';

class DepartmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Department>> fetchDepartments() async {
    try {
      final snapshot = await _firestore.collection('departments').get();
      return snapshot.docs.map((doc) => Department.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch departments: $e');
    }
  }
}
