import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/linked_accounts_model.dart';

Future<List<LinkAccountsModel>> fetchedLinkedAccounts(
    {required String uid}) async {
  try {
    List<LinkAccountsModel> list = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('linked_accounts').get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (var document in documents) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      LinkAccountsModel obj = LinkAccountsModel.fromJson(data);

      if (obj.uid == uid) list.add(obj);
    }

    return list;
  } catch (err) {
    return [];
  }
}
