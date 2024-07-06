import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app_user/models/user.dart';
import 'package:app_user/pages/asd.dart';

class UserDetailPage extends StatefulWidget {
  final User user;

  UserDetailPage({required this.user});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final ApiService apiService = ApiService();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _events = {};

  void _addEvent(String event) {
    setState(() {
      if (_events[_selectedDay] == null) {
        _events[_selectedDay!] = [];
      }
      _events[_selectedDay]!.add(event);
    });
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
              Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    widget.user.phone,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    widget.user.address,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
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
