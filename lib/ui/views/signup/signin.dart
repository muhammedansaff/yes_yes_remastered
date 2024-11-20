import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart'; // Ensure provider package is imported
import 'package:yes_yes/app/app.router.dart';
import 'package:yes_yes/constants/utils.dart';
import 'package:yes_yes/gen/assets.gen.dart';
import 'package:yes_yes/ui/refactored/button.dart';
import 'package:yes_yes/ui/refactored/mytextfield.dart';
import 'package:yes_yes/ui/views/signup/signup_viewmodel.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: primaryColor,
            body: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 25,
                          ),
                          Hero(
                            tag: "img",
                            child: SvgPicture.asset(
                              Assets.mainlogo,
                              width: screenWidth * 0.15,
                              height: screenHeight * 0.15,
                            ),
                          ),
                          const SizedBox(width: 22),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
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
                                SizedBox(height: screenHeight * 0.05),
                                const Text(
                                  "WELCOME",
                                  style: TextStyle(
                                    fontFamily: "ansaf",
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                Mytextfield(focusNode: viewModel.fullNameFocusNode,
                                  type: "name",
                                  icon: Icons.person,
                                  hinttext: "Full Name",
                                  controller: viewModel.fullNameController,
                                  validator: viewModel.validateFullName,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Mytextfield(focusNode: viewModel.emailFocusNode,
                                  type: "email",
                                  icon: Icons.mail_sharp,
                                  hinttext: "Email Id",
                                  controller: viewModel.emailController,
                                  validator: viewModel.validateEmail,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Mytextfield(focusNode: viewModel.createPasswordFocusNode,
                                  type: "create",
                                  icon: Icons.key,
                                  hinttext: "Create Password",
                                  controller:
                                      viewModel.createPasswordController,
                                  validator: viewModel.validatePassword,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Mytextfield(focusNode: viewModel.confirmPasswordFocusNode,
                                  type: "confirm",
                                  icon: Icons.lock,
                                  hinttext: "Confirm Password",
                                  controller:
                                      viewModel.confirmPasswordController,
                                  validator: viewModel.validateConfirmPassword,
                                ),
                                SizedBox(height: screenHeight * 0.05),
                                viewModel.isLoading
                                    ? CircularProgressIndicator(
                                        color: buttoncolor)
                                    : MyButton(
                                        width: screenWidth * 0.7,
                                        height: screenHeight * 0.07,
                                        onPressed: () {
                                          if (viewModel.formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            viewModel.signUp(context);
                                          }
                                        },
                                        text: "Sign Up",
                                        col: buttoncolor,
                                        textcolor: Colors.white,
                                        isoutline: true,
                                        texsize: 16,
                                      ),
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "ansaf",
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                            context, Routes.loginScreen);
                                      },
                                      child: const Text(
                                        "Log In",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "ansaf",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
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
          );
        },
      ),
    );
  }
}
