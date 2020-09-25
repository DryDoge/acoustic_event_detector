import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDao {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getRightsForUser(String userId) async {
    final DocumentSnapshot docSnap = await _firestore
        .collection(FirebaseConst.userCollection)
        .doc(userId)
        .get();

    return docSnap.data();
  }
}
