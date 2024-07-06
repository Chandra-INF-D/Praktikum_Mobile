import 'package:flutter/material.dart';
import 'package:app_user/models/user.dart';

class AddUserPage extends StatefulWidget {
  final Function(User) onUserAdded;

  const AddUserPage({
    Key? key,
    required this.onUserAdded,
  }) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void addUser() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String address = addressController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    int id = DateTime.now().millisecondsSinceEpoch; // Generate unique ID based on timestamp
    String avatarUrl = 'https://example.com/avatar.png';

    User newUser = User(
      id: id,
      avatar: avatarUrl,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
    );

    widget.onUserAdded(newUser);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal, Colors.teal.shade900],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: addUser,
                child: Text('Tambahkan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
