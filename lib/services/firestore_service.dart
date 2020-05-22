import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  // Singleton only one instance is created 
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('FIRESTORE: $path => $data');
    await reference.setData(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path, 
    @required T builder(Map<String, dynamic> data)
  }){
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((e) => builder(e.data)).toList());
  }
}