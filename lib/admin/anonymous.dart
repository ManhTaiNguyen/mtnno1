import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtnno1/widget/widget_support.dart';

class Anonymous extends StatefulWidget {
  const Anonymous({Key? key}) : super(key: key);

  @override
  State<Anonymous> createState() => _AnonymousState();
}

class _AnonymousState extends State<Anonymous> {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController newpasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFF373866),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Quản lý Admin",
          style: AppWidget.HeadlineTextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thêm Admin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildTextField("Username", usernamecontroller),
            SizedBox(height: 8),
            _buildTextField("Password", passwordcontroller, obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _createAdmin(usernamecontroller.text, passwordcontroller.text);
              },
              child: Text('Thêm'),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 24),
            Text(
              'Danh sách Admin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildAdminList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAdminList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Admin').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            return ListTile(
              title: Text(doc['id']),
              subtitle: Text('********'), // Che mật khẩu
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditDialog(context, doc.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteAdmin(doc.id);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _createAdmin(String id, String password) {
    FirebaseFirestore.instance.collection("Admin").doc(id).set({
      'id': id,
      'password': password,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text(
          "Đăng ký thành công!",
          style: TextStyle(fontSize: 20),
        ),
      )));
      usernamecontroller.clear();
      passwordcontroller.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error creating admin: $error"),
      ));
    });
  }

  void _deleteAdmin(String id) {
    FirebaseFirestore.instance.collection("Admin").doc(id).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Đã xóa",
          style: TextStyle(fontSize: 20),
        ),
      )));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error deleting admin: $error"),
      ));
    });
  }

  void _updateAdmin(String id, String newPassword) {
    FirebaseFirestore.instance.collection("Admin").doc(id).update({
      'password': newPassword,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text(
          "Sửa thành công!",
          style: TextStyle(fontSize: 20),
        ),
      )));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error updating admin: $error"),
      ));
    });
  }

  void _showEditDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sửa mật khẩu cho $id'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Mật khẩu mới", newpasswordcontroller),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateAdmin(id, newpasswordcontroller.text);
                Navigator.of(context).pop();
              },
              child: Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }
}
