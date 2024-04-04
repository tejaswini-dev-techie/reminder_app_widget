import 'package:flutter/material.dart';
import 'package:reminder_app/ReminderScreen/reminder_screen.dart';

class ReminderDetailsScreen extends StatefulWidget {
  final String title;
  final String description;
  const ReminderDetailsScreen(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  _ReminderDetailsScreenState createState() => _ReminderDetailsScreenState();
}

class _ReminderDetailsScreenState extends State<ReminderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reminder Details'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<ReminderScreen>(
                builder: (context) {
                  return const ReminderScreen();
                },
              ),
            ),
            icon: const Icon(
              Icons.home_outlined,
              size: 28,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
