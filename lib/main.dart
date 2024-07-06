import 'package:flutter/material.dart';
import 'package:app_user/models/user.dart';
import 'package:app_user/pages/user_detail_page.dart';
import 'package:app_user/pages/add_user_page.dart';
import 'package:app_user/pages/asd.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kunjungan',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ApiService apiService = ApiService();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUserList();
  }

  Future<void> fetchUserList() async {
    try {
      List<User> fetchedUsers = await apiService.fetchUsers();
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void addUserToList(User newUser) {
    setState(() {
      users.add(newUser);
    });
  }

  void _removeUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Pengunjung'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
              ),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(user.email),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _removeUser(index);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailPage(user: user),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserPage(
                onUserAdded: addUserToList,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
