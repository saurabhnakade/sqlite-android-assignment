// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myown_sqfilte/helper/sql_helper.dart';
import 'package:myown_sqfilte/model/user_model.dart';
import 'package:myown_sqfilte/user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key? key,
      this.username = "",
      this.password = "",
      this.isUpdate = false,
      this.id = -1})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  final String username, password;
  final bool isUpdate;
  final int id;
}

class _HomePageState extends State<HomePage> {
  void _getAllUsers() async {
    final data = await SQLHelper.getItems();
    setState(() {
      UserModel.allUsers = data;
    });
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAllUsers();
    usernameController.text = widget.username;
    passwordController.text = widget.password;
  }

  Future<void> _addUser() async {
    await SQLHelper.createItem(
        UserModel.username.toString(), UserModel.password.toString());
    _getAllUsers();
  }

  Future<void> _updateUser(int id) async {
    await SQLHelper.updateItem(
        id, UserModel.username.toString(), UserModel.password.toString());
    _getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.isUpdate ? "Update" : "Login";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 20, bottom: 0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter valid Name id ',
                    ),
                    controller: usernameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password',
                    ),
                    controller: passwordController,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        UserModel.username = usernameController.text;
                        UserModel.password = passwordController.text;
                      });

                      widget.isUpdate
                          ? await _updateUser(widget.id)
                          : await _addUser();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserData(),
                        ),
                      );
                    },
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                SizedBox(height: 130),
                widget.isUpdate
                    ? Container()
                    : InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserData(),
                            ),
                          );
                        },
                        child: Text('See All Users'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
