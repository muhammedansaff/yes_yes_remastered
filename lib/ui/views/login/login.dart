import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yes_yes/constants/utils.dart';
import 'package:yes_yes/gen/assets.gen.dart';
import 'package:yes_yes/ui/refactored/button.dart';
import 'package:yes_yes/ui/refactored/mytextfield.dart';
import 'package:yes_yes/ui/views/forgotpassword/forgotpassword.dart';
import 'package:yes_yes/ui/views/login/viewmodel_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        resizeToAvoidBottomInset: true,
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
                    height: 20,
                  ),
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
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                            const Text(
                              "WELCOME BACK!",
                              style: TextStyle(
                                fontFamily: "ansaf",
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.04,
                            ),
                            Mytextfield(focusNode: viewModel.emailFocusNode,
                              type: "email",
                              icon: Icons.mail_sharp,
                              hinttext: "Email Id",
                              controller: viewModel.emailController,
                              validator: viewModel.validateEmail,
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Mytextfield(
                             focusNode: viewModel.passwordFocusNode,
                              type: "passwordd",
                              icon: Icons.lock,
                              hinttext: "Password",
                              controller: viewModel.passwordController,
                              validator: viewModel.validatePassword,
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: screenWidth * 0.15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.5,
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Forgotpasswordscreen()));
                                    },
                                    child: const Text(
                                      "Forget Password?",
                                      style: TextStyle(
                                          fontFamily: "ansaf",
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  //  SizedBox(width: screenHeight* .09,),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.08,
                            ),
                            viewModel.isLoading
                                ? CircularProgressIndicator(
                                    color: buttoncolor,
                                  )
                                : MyButton(
                                    width: screenWidth * 0.7,
                                    height: screenHeight * 0.06,
                                    onPressed: viewModel.onLoginPressed,
                                    text: "LOGIN",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "ansaf",
                                      fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: viewModel.navigateToSignUp,
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "ansaf",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                )
                              ],
                            )
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
