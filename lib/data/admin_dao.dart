import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class AdminDao {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createUser({
    @required String userId,
    @required int rights,
    @required String email,
  }) async {
    try {
      await _firestore
          .collection(FirebaseConst.userCollection)
          .doc(userId)
          .set({
        FirebaseConst.emailField: email,
        FirebaseConst.rightsField: rights,
      });
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
