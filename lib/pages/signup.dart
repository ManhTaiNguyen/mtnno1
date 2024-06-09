import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtnno1/pages/bottomnav.dart';
import 'package:mtnno1/pages/login.dart';
import 'package:mtnno1/service/database.dart';
import 'package:mtnno1/service/shared_pref.dart';
import 'package:mtnno1/widget/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";

  TextEditingController namecontroller = new TextEditingController();

  TextEditingController passwordcontroller = new TextEditingController();

  TextEditingController mailcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registrtion() async {
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            "Đăng ký thành công!",
            style: TextStyle(fontSize: 20),
          ),
        )));
        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Wallet": "0",
          "Id": Id,
        };
        await DatabaseMethods().addUserDetail(addUserInfo, Id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserWallet('0');
        await SharedPreferenceHelper().saveUserId(Id);
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Mật khẩu quá dễ đoán!!!",
              style: TextStyle(fontSize: 18),
            ),
          )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Tài khoản này đã tồn tại!",
              style: TextStyle(fontSize: 18),
            ),
          )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFff5c30), Color(0xFFe74b1a)])),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Text(""),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "images/logo-mtn.png",
                      width: MediaQuery.of(context).size.width / 1.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formkey,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "Đăng ký",
                                style: AppWidget.HeadlineTextFieldStyle(),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: namecontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập lại tên!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Họ và tên',
                                    hintStyle:
                                        AppWidget.SemiBoldTextFieldStyle(),
                                    suffixIcon: Icon(Icons.person_outlined)),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: mailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập lại Email!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle:
                                        AppWidget.SemiBoldTextFieldStyle(),
                                    suffixIcon: Icon(Icons.email_outlined)),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: passwordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập lại mật khẩu!';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: 'Mật khẩu',
                                    hintStyle:
                                        AppWidget.SemiBoldTextFieldStyle(),
                                    suffixIcon: Icon(Icons.password_outlined)),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      email = mailcontroller.text;
                                      name = namecontroller.text;
                                      password = passwordcontroller.text;
                                    });
                                  }
                                  registrtion();
                                },
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Color(0xffff5722),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: Text("ĐĂNG KÝ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Bạn đã có tài khoản? Đăng nhập",
                      style: AppWidget.SemiBoldTextFieldStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
