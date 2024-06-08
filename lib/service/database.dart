import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .set(userInfoMap);
  }

  // UpdateUserwallet(String id, String amount) async {
  //   return await FirebaseFirestore.instance
  //       .collection("user")
  //       .doc(id)
  //       .update({"Wallet": amount});
  // }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }
}
