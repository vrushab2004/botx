import 'dart:io';
import 'theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'event_model.dart'; // Import the EventModel class

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

  Future<String?> _uploadImage(File image) async {
    try {
      if (!await image.exists()) {
        print('File does not exist.');
        return null;
      }

      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('event_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      print('Uploading image to: ${imageRef.fullPath}');

      final uploadTask = imageRef.putFile(image);
      final taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        final downloadURL = await imageRef.getDownloadURL();
        print('Image uploaded successfully. Download URL: $downloadURL');
        return downloadURL;
      } else {
        print('Image upload failed. Task state: ${taskSnapshot.state}');
        return null;
      }
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> _submitEvent() async {
    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    String creatorId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (creatorId.isEmpty) {
      print('Error: User is not logged in');
      return;
    }

    EventModel newEvent = EventModel(
      eventName: _eventNameController.text,
      speakerName: _speakerNameController.text,
      stageName: _stageNameController.text,
      stageCapacity: _stageCapacityController.text,
      dateTime: _selectedDateTime,
      description: _descriptionController.text,
      imageUrl: imageUrl,
      creatorId: creatorId, // Set the creatorId here
    );

    await FirebaseFirestore.instance.collection('events').add(newEvent.toMap());

    Navigator.pop(context, newEvent);
  }

  List<Step> getSteps() {
    return [
      Step(
        title: const Text('Event Name'),
        content: TextField(
          controller: _eventNameController,
          cursorColor: CustomColors.buttoncolor,
          decoration: const InputDecoration(
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
        title: const Text('Speaker Name'),
        content: TextField(
          controller: _speakerNameController,
          cursorColor: CustomColors.buttoncolor,
          decoration: const InputDecoration(
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
        title: const Text('Stage Name'),
        content: TextField(
          controller: _stageNameController,
          cursorColor: CustomColors.buttoncolor,
          decoration: const InputDecoration(
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
        title: const Text('Stage Capacity'),
        content: TextField(
          controller: _stageCapacityController,
          cursorColor: CustomColors.buttoncolor,
          decoration: const InputDecoration(
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
          decoration: const InputDecoration(
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
            margin: const EdgeInsets.only(right: 10),
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
                    backgroundColor: const Color.fromARGB(255, 113, 149, 228),
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
