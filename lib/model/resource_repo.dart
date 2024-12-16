import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsview/model/resource.dart';

class ResourceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Resource>> fetchResources(String departmentId, String semesterId) async {
    try {
      final snapshot = await _firestore
          .collection('departments')
          .doc(departmentId)
          .collection('semesters')
          .doc(semesterId)
          .collection('resources')
          .get();

      return snapshot.docs.map((doc) => Resource.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch resources: $e');
    }
  }
}
