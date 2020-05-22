import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  // Singleton only one instance is created 
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({@required String path, @required Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    //print('FIRESTORE: $path => $data');
    await reference.setData(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path, 
    @required T builder(Map<String, dynamic> data,  String documentID),
  }){
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((e) => builder(e.data, e.documentID)).toList());
  }

  Future<void> deleteData({@required String path}) async{
    final reference = Firestore.instance.document(path);
    print('FIRESTORE (delete): $path');
    await reference.delete();
  }
}