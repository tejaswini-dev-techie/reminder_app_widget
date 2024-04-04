// Consider using a form key to validate the form before submission
// Consider using a loading indicator while saving the reminder

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:reminder_app/Constants/app_constants.dart';
import 'package:reminder_app/ReminderDetailsScreen/reminder_details_screen.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isRequestPinWidgetSupported = false;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(AppConstants.appGroupId);
    HomeWidget.registerInteractivityCallback(interactiveCallback);
    _checkPinability();

    // Listen to changes in the text fields to update the button state
    _titleController.addListener(() {
      _updateButtonState();
    });
    _descriptionController.addListener(() {
      _updateButtonState();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  @pragma("vm:entry-point")
  Future<void> interactiveCallback(Uri? data) async {
    if (data?.host == 'titleclicked') {
      await HomeWidget.setAppGroupId(AppConstants.appGroupId);
      await HomeWidget.updateWidget(
        name: AppConstants.androidWidgetName,
        iOSName: AppConstants.iOSWidgetName,
        qualifiedAndroidName: AppConstants.qualifiedAndroidName,
      );
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          name: AppConstants.androidWidgetName,
          iOSName: AppConstants.iOSWidgetName,
          qualifiedAndroidName: AppConstants.qualifiedAndroidName,
        );
      }
    }
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _titleController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty;
    });
  }

  Future _sendData() async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('title', _titleController.text),
        HomeWidget.saveWidgetData<String>(
            'description', _descriptionController.text),
        HomeWidget.renderFlutterWidget(
          const Icon(
            Icons.flutter_dash,
            size: 60,
            color: Color(0xff23395d),
          ),
          logicalSize: const Size(60, 60),
          key: 'dashIcon',
        ),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future _updateWidget() async {
    try {
      return Future.wait([
        HomeWidget.updateWidget(
          name: AppConstants.androidWidgetName,
          iOSName: AppConstants.iOSWidgetName,
          qualifiedAndroidName: AppConstants.qualifiedAndroidName,
        ),
        if (Platform.isAndroid)
          HomeWidget.updateWidget(
            name: AppConstants.androidWidgetName,
            iOSName: AppConstants.iOSWidgetName,
            qualifiedAndroidName: AppConstants.qualifiedAndroidName,
          ),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  Future<void> _checkForWidgetLaunch() async {
    await _loadData();
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  Future _loadData() async {
    try {
      return Future.wait([
        HomeWidget.getWidgetData<String>('title', defaultValue: '')
            .then((value) => _titleController.text = value ?? ''),
        HomeWidget.getWidgetData<String>(
          'description',
          defaultValue: '',
        ).then((value) => _descriptionController.text = value ?? ''),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      // Navigate to Reminder Details Screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<ReminderDetailsScreen>(
          builder: (context) {
            return ReminderDetailsScreen(
              title: _titleController.text,
              description: _descriptionController.text,
            );
          },
        ),
      );
    }
  }

  Future<void> _checkPinability() async {
    final isRequestPinWidgetSupported =
        await HomeWidget.isRequestPinWidgetSupported();
    if (mounted) {
      setState(() {
        _isRequestPinWidgetSupported = isRequestPinWidgetSupported ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Reminder Title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                decoration:
                    const InputDecoration(hintText: 'Reminder Description'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _saveReminder : null,
                child: const Text('Set Reminder'),
              ),
              if (_isRequestPinWidgetSupported)
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _pinWidgetRequest : null,
                  child: const Text('Pin Widget'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveReminder() async {
    // Save the reminder
    await _sendAndUpdate();
  }

  void _pinWidgetRequest() {
    HomeWidget.requestPinWidget(
      name: AppConstants.androidWidgetName,
      androidName: AppConstants.androidWidgetName,
      qualifiedAndroidName: AppConstants.qualifiedAndroidName,
    );
  }
}
