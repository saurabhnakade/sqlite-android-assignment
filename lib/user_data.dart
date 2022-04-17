// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myown_sqfilte/helper/sql_helper.dart';
import 'package:myown_sqfilte/home_page.dart';
import 'package:myown_sqfilte/model/user_model.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  void _getAllUsers() async {
    final data = await SQLHelper.getItems();
    setState(() {
      UserModel.allUsers = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllUsers();
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

  void _deleteUser(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          'Successfully deleted a user',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
    _getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("All Users Data"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: UserModel.allUsers.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              if (index == 0) SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: ListTile(
                    trailing: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              username: UserModel.allUsers[index]["username"],
                              password: UserModel.allUsers[index]["password"],
                              id: UserModel.allUsers[index]["id"],
                              isUpdate: true,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.edit, size: 30),
                    ),
                    leading: Icon(
                      Icons.person,
                      size: 35,
                    ),
                    onLongPress: () {
                      _deleteUser(UserModel.allUsers[index]['id']);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          UserModel.allUsers[index]['username'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      " ${UserModel.allUsers[index]['password']}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // Divider(color: Colors.white38),
            ],
          );
        },
      ),
    );
  }
}
