import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_yes/constants/utils.dart';
import 'dart:io' as io;

import 'package:yes_yes/ui/views/home/screens/Leavescreen/viewmodelleave.dart';

class Leavescreen extends StatelessWidget {
  const Leavescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<Viewmodelleave>.reactive(
      viewModelBuilder: () => Viewmodelleave(),
      builder: (BuildContext context, Viewmodelleave viewModel, Widget? child) {
        return Scaffold(
          extendBody: true,
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            title: Text('Leave Application',
                style: TextStyle(color: secondarycolor)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: secondarycolor),
                onPressed: () {},
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                width: screenWidth,
                height: 400,
                color: primaryColor,
              ),
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: Form(
                        child: ListView(
                          children: [
                            const SizedBox(height: 30),
                            DropdownButtonFormField<String>(
                              value: viewModel.selectedLeaveType,
                              decoration: InputDecoration(
                                labelText: 'Leave Type',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon:
                                    Icon(Icons.category, color: primaryColor),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              items: <String>[
                                'Medical',
                                'Emergency',
                                'Personal'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                viewModel.setLeaveType(newValue);
                              },
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: viewModel.reasonController,
                              decoration: InputDecoration(
                                labelText: "Reason for Leave",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon: Icon(Icons.text_fields,
                                    color: primaryColor),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a reason';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: ListTile(
                                title: const Text('Select Date'),
                                subtitle: Text(
                                  viewModel.selectedDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(viewModel.selectedDate!)
                                      : 'No date selected',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.calendar_today,
                                      color: primaryColor),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      viewModel.pickDate(pickedDate);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            if (viewModel.selectedLeaveType == 'Medical') ...[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade300),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (kIsWeb) {
                                      final result = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (result != null) {
                                        final imageBytes =
                                            await result.readAsBytes();
                                        viewModel.pickImageWeb(imageBytes);
                                      }
                                    } else {
                                      final result = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (result != null) {
                                        final imageFile = io.File(result.path);
                                        viewModel.pickImage(imageFile);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    overlayColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: BorderSide(
                                        width: 1, color: Colors.grey.shade300),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Upload Medical Receipt',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Icon(Icons.image,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 10),
                            if (viewModel.selectedLeaveType == 'Medical') ...[
                              if (viewModel.selectedImage != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 3)),
                                    child: Image.file(viewModel.selectedImage!,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              if (viewModel.webImage != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.memory(viewModel.webImage!),
                                ),
                            ],
                            const SizedBox(height: 30),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width < 500
                                    ? MediaQuery.of(context).size.width * 0.8
                                    : 300, // Set a maximum width for larger screens
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Replace this with actual userId or username fetching
                                    String userId = "example_user_id";

                                    if (viewModel.selectedLeaveType ==
                                            'Medical' &&
                                        viewModel.selectedImage == null &&
                                        viewModel.webImage == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: const Text(
                                              'Please upload a medical receipt'),
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      bool success = await viewModel
                                          .submitLeaveApplication(
                                              userId, context);
                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: primaryColor,
                                            content: const Text(
                                                'Leave submitted successfully'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              'Failed to submit leave: ${e.toString()}'),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                  ),
                                  child: viewModel.isLoading
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        )
                                      : const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
