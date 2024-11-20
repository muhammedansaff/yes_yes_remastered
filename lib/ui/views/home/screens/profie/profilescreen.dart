import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yes_yes/constants/utils.dart';
import 'package:yes_yes/ui/views/home/screens/profie/viewmodelprofilel.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<Viewmodelprofile>.reactive(
      viewModelBuilder: () => Viewmodelprofile(),
      builder:
          (BuildContext context, Viewmodelprofile viewModel, Widget? child) {
        return Scaffold(
          extendBody: true,
          backgroundColor: primaryColor,
          drawer: const Drawer(
            backgroundColor: Colors.white,
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
                  SizedBox(
                    height: screenHeight * 0.12598,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 32.0), // Adjust padding
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: FutureBuilder<Map<String, dynamic>?>(
                        future: viewModel.getUserData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error fetching data'));
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Center(
                                child: Text('No user data found'));
                          }

                          Map<String, dynamic>? userData = snapshot.data;
                          String fullName = userData?['fullName'] ?? 'No Name';
                          String email = userData?['email'] ?? 'No Email';

                          return ListView(
                            children: [
                              Center(
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: primaryColor,
                                  child: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  fullName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width < 500
                                      ? MediaQuery.of(context).size.width * 0.8
                                      : 300, // Set a maximum width for larger screens
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 12.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      viewModel.signout();
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
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
