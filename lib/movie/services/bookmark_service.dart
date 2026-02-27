import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addBookmark({
    required int id,
    required String title,
    required String posterPath,
  }) async {
    final uid = _auth.currentUser!.uid;

    await _firestore
        .collection("users")
        .doc(uid)
        .collection("bookmarks")
        .doc(id.toString())
        .set({
      "id": id,
      "title": title,
      "posterPath": posterPath,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeBookmark(int id) async {
    final uid = _auth.currentUser!.uid;

    await _firestore
        .collection("users")
        .doc(uid)
        .collection("bookmarks")
        .doc(id.toString())
        .delete();
  }

  Future<bool> isBookmarked(int id) async {
    final uid = _auth.currentUser!.uid;

    final doc = await _firestore
        .collection("users")
        .doc(uid)
        .collection("bookmarks")
        .doc(id.toString())
        .get();

    return doc.exists;
  }
}
