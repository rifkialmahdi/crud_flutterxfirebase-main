import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  
  final CollectionReference notes =
    FirebaseFirestore.instance.collection('cucian');

  Future<Future<DocumentReference<Object?>>> addCucian(String nama, String berat, String layanan) async {
    return notes.add({
      'nama': nama,
      'berat': berat,
      'layanan': layanan,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot<Object?>> getCucian() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> deleteCucian(String id) async {
    return notes.doc(id).delete();
  }

  Future<void> updateCucian(String id, String nama, String berat, String layanan) async {
    return notes.doc(id).update({
      'nama': nama,
      'berat': berat,
      'layanan': layanan,
    });
  }
}

