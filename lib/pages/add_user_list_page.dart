import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app_user/models/user.dart';
import 'package:app_user/services/api_service.dart';

class UserDetailPage extends StatefulWidget {
  final User user;

  UserDetailPage({required this.user});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final ApiService apiService = ApiService();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    emailController.text = widget.user.email;
    phoneController.text = widget.user.phone;
    addressController.text = widget.user.address;
  }

  void _addEvent(String event) {
    setState(() {
      if (_events[_selectedDay] == null) {
        _events[_selectedDay!] = [];
      }
      _events[_selectedDay]!.add(event);
    });
  }

  Future<void> _updateUser() async {
    try {
      User updatedUser = User(
        id: widget.user.id,
        avatar: widget.user.avatar,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
      );

      await apiService.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User updated successfully')),
      );

      setState(() {
        widget.user.firstName = firstNameController.text;
        widget.user.lastName = lastNameController.text;
        widget.user.email = emailController.text;
        widget.user.phone = phoneController.text;
        widget.user.address = addressController.text;
      });
    } catch (e) {
      print('Error updating user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Data Pengunjung'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.user.avatar),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  '${widget.user.firstName} ${widget.user.lastName}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  widget.user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Informasi Pribadi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text('Simpan Perubahan'),
              ),
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Event Kalender',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TableCalendar(
                firstDay: DateTime.utc(2023, 01, 01),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                eventLoader: (day) {
                  return _events[day] ?? [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              SizedBox(height: 8),
              if (_selectedDay != null) ...[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Tambah Event',
                  ),
                  onSubmitted: (value) {
                    _addEvent(value);
                  },
                ),
                SizedBox(height: 8),
                ..._events[_selectedDay!]!.map((event) => ListTile(
                      title: Text(event),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
