import 'dart:io';

import 'theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EventDetails {
  String eventName;
  String speakerName;
  String stageName;
  String stageCapacity;
  DateTime? dateTime;
  String description;
  File? image;

  EventDetails({
    required this.eventName,
    required this.speakerName,
    required this.stageName,
    required this.stageCapacity,
    required this.dateTime,
    required this.description,
    this.image,
  });
}

class Addevent extends StatefulWidget {
  const Addevent({Key? key}) : super(key: key);

  @override
  State<Addevent> createState() => _AddeventState();
}

class _AddeventState extends State<Addevent> {
  int currentStep = 0;
  DateTime? _selectedDateTime;
  File? _selectedImage;
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _speakerNameController = TextEditingController();
  final TextEditingController _stageNameController = TextEditingController();
  final TextEditingController _stageCapacityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate == null) return;

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );

    if (selectedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitEvent() {
    // Save event details and navigate back
    EventDetails newEvent = EventDetails(
      eventName: _eventNameController.text,
      speakerName: _speakerNameController.text,
      stageName: _stageNameController.text,
      stageCapacity: _stageCapacityController.text,
      dateTime: _selectedDateTime,
      description: _descriptionController.text,
      image: _selectedImage,
    );

    Navigator.pop(context, newEvent);
  }

  List<Step> getSteps() {
    return [
      Step(
        title: Text('Event Name'),
        content: TextField(
          controller: _eventNameController,
          cursorColor: CustomColors.buttoncolor,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: CustomColors.buttoncolor,
              ),
            ),
          ),
        ),
        isActive: true,
      ),
      Step(
        title: Text('Speaker Name'),
        content: TextField(
          controller: _speakerNameController,
          cursorColor: CustomColors.buttoncolor,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: CustomColors.buttoncolor,
              ),
            ),
          ),
        ),
        isActive: true,
      ),
      Step(
        title: Text('Stage Name'),
        content: TextField(
          controller: _stageNameController,
          cursorColor: CustomColors.buttoncolor,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: CustomColors.buttoncolor,
              ),
            ),
          ),
        ),
        isActive: true,
      ),
      Step(
        title: Text('Stage Capacity'),
        content: TextField(
          controller: _stageCapacityController,
          cursorColor: CustomColors.buttoncolor,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: CustomColors.buttoncolor,
              ),
            ),
          ),
        ),
        isActive: true,
      ),
      Step(
        title: const Text('Time and Date'),
        content: Column(
          children: [
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: const Text('Select Date and Time'),
            ),
            if (_selectedDateTime != null)
              Text('Selected DateTime: $_selectedDateTime'),
          ],
        ),
        isActive: true,
      ),
      Step(
        title: const Text('Description'),
        content: TextField(
          controller: _descriptionController,
          maxLines: 3,
          cursorColor: CustomColors.buttoncolor,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: CustomColors.buttoncolor,
              ),
            ),
          ),
        ),
        isActive: true,
      ),
      Step(
        title: const Text('Add Image'),
        content: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
                width: 200,
              ),
          ],
        ),
        isActive: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.buttoncolor,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: _submitEvent,
              child: Text(
                'Done',
                style: GoogleFonts.aBeeZee(color: const Color.fromARGB(255, 112, 241, 116), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.white),
        ),
        title: Text(
          'Create Event',
          style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Stepper(
        currentStep: currentStep,
        steps: getSteps(),
        type: StepperType.vertical,
        onStepTapped: (int step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepCancel: () {
          setState(() {
            if (currentStep > 0) {
              currentStep -= 1;
            }
          });
        },
        onStepContinue: () {
          setState(() {
            if (currentStep < getSteps().length - 1) {
              currentStep += 1;
            } else {
              currentStep = 0;
            }
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.buttoncolor,
                  ),
                  child: const Text('CONTINUE', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: details.onStepCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 113, 149, 228),
                  ),
                  child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
