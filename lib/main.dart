import 'package:app_user/pages/asd.dart';
import 'package:flutter/material.dart';
import 'package:app_user/pages/user_detail_page.dart' as detail;
import 'package:app_user/pages/add_user_page.dart' as add;
import 'package:app_user/models/user.dart';


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
        scaffoldBackgroundColor: Colors.white, // Background color for scaffold
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
  List<User> users = []; // List of users

  @override
  void initState() {
    super.initState();
    fetchUserList(); // Fetch initial user list when page loads
  }

  Future<void> fetchUserList() async {
    try {
      List<User> fetchedUsers = await apiService.fetchUsers();
      setState(() {
        users = fetchedUsers; // Update state with fetched users
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  // Function to add user to the list
  void addUserToList(User newUser) {
    setState(() {
      users.add(newUser); // Add new user to the list
    });
  }

  // Function to remove user from the list
  void _removeUser(int index) {
    setState(() {
      users.removeAt(index); // Remove user at the specified index
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
                  _removeUser(index); // Call function to remove user
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => detail.UserDetailPage(userId: user.id),
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
              builder: (context) => add.AddUserPage(
                onUserAdded: addUserToList, // Pass callback function to AddUserPage
                phone: '', // Provide required parameters
                address: '', // Provide required parameters
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
