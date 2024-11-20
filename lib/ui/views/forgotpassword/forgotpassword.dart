import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:yes_yes/constants/utils.dart';

import 'package:yes_yes/ui/refactored/button.dart';
import 'package:yes_yes/ui/refactored/mytextfield.dart';
import 'package:yes_yes/ui/views/forgotpassword/viewmodelforgot.dart';

class Forgotpasswordscreen extends StatelessWidget {
  const Forgotpasswordscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<Forgetviewmodel>.reactive(
      viewModelBuilder: () => Forgetviewmodel(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Hero(
                tag: "hello",
                child: Material(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    height: screenHeight * 0.7,
                    child: Form(
                      key: viewModel.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                            const Text(
                              "Forgot your password!",
                              style: TextStyle(
                                fontFamily: "ansaf",
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.04,
                            ),
                            Mytextfield(
                              focusNode: viewModel.forgotpasswordnode,
                              type: "email",
                              icon: Icons.mail_sharp,
                              hinttext: "Email Id",
                              controller: viewModel.emailController,
                              validator: viewModel.validateEmail,
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            SizedBox(
                              height: screenHeight * 0.001,
                            ),
                            viewModel.isLoading
                                ? CircularProgressIndicator(
                                    color: buttoncolor,
                                  )
                                : MyButton(
                                    width: screenWidth * 0.7,
                                    height: screenHeight * 0.06,
                                    onPressed: () {
                                      viewModel.resetPassword(context);
                                    },
                                    text: "Reset",
                                    col: buttoncolor,
                                    textcolor: Colors.white,
                                    isoutline: true,
                                    texsize: 16,
                                  ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
