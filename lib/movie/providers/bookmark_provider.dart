import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookmarkProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isSaved = false;

  Future<void> checkBookmark(int movieId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(movieId.toString())
        .get();

    isSaved = doc.exists;
    notifyListeners();
  }

  /// ============================
  /// ADD BOOKMARK + OVERVIEW
  /// ============================
  Future<void> addBookmark({
    required int id,
    required String title,
    required String poster,
    required String overview,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(id.toString())
        .set({
      'id': id,
      'title': title,
      'poster': poster,
      'overview': overview,
      'dateSaved': DateTime.now().toIso8601String(),
    });

    isSaved = true;
    notifyListeners();
  }

  Future<void> removeBookmark(int id) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(id.toString())
        .delete();

    isSaved = false;
    notifyListeners();
  }

  Stream<List<Map<String, dynamic>>> getBookmarks() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .orderBy('dateSaved', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }
}
