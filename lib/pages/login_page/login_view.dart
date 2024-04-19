import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:cashify/widgets/titled_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          return Stack(
            children: [
              Column(
                children: [
                  ShapeOfView(
                    elevation: 0,
                    height: width * 1.4,
                    width: width,
                    shape: DiagonalShape(
                      position: DiagonalPosition.Bottom,
                      direction: DiagonalDirection.Right,
                      angle: DiagonalAngle.deg(angle: 30),
                    ),
                    child: Container(
                      color: mainColor,
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          SafeArea(child: Text('welcome statemnet'))
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: width * 0.1),
                    child: Container(
                      width: width * 0.2,
                      height: width * 0.2,
                      color: Colors.grey[200],
                      child: const Placeholder(),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            offset: const Offset(0, 0),
                            blurRadius: 10,
                          )
                        ],
                        color: forgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                        height: width * 1.1,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24.0, horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitledInput(
                                enabled: false,
                                active: true,
                                title: 'Email Adress',
                                titleSize: 12,
                                titleColor: mainColor,
                                width: width,
                                textColor: Colors.grey.shade400,
                              ),
                              SizedBox(
                                height: width * 0.04,
                              ),
                              TitledInput(
                                password: true,
                                obscurePass: false,
                                active: false,
                                title: 'Password',
                                titleSize: 12,
                                titleColor: mainColor,
                                width: width,
                                textColor: mainColor,
                              ),
                              SizedBox(
                                height: width * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: CustomText(
                                      text: 'Forgot Password ?',
                                      color: Colors.grey.shade500,
                                      size: 12,
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              ),
                              SizedBox(
                                height: width * 0.05,
                              ),
                              Center(
                                child: ButtonWidget(
                                  width: width * 0.7,
                                  height: width * 0.1,
                                  textColor: backgroundColor,
                                  color: mainColor,
                                  isIos: true,
                                  textSize: 22,
                                  type: ButtonType.raised,
                                  onClick: () {},
                                  text: 'Login',
                                ),
                              ),
                              SizedBox(
                                height: width * 0.05,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: (width * 0.7) * 0.45,
                                    child: Divider(
                                      thickness: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: (width * 0.7) * 0.025),
                                    child: CustomText(
                                      text: 'or',
                                      size: 12,
                                      color: mainColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (width * 0.7) * 0.45,
                                    child: Divider(
                                      thickness: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: width * 0.05,
                              ),
                              Center(
                                child: SizedBox(
                                  width: width * 0.7,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: width * 0.13,
                                        width: width * 0.13,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: shadowColor,
                                              offset: const Offset(0, 0),
                                              blurRadius: 5,
                                            ),
                                          ],
                                          color: forgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.google,
                                            color: mainColor,
                                            size: width * 0.08,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: width * 0.13,
                                        width: width * 0.13,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: shadowColor,
                                              offset: const Offset(0, 0),
                                              blurRadius: 5,
                                            )
                                          ],
                                          color: forgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.phone,
                                            color: mainColor,
                                            size: width * 0.08,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: width * 0.13,
                                        width: width * 0.13,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: shadowColor,
                                              offset: const Offset(0, 0),
                                              blurRadius: 5,
                                            )
                                          ],
                                          color: forgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.envelope,
                                            color: mainColor,
                                            size: width * 0.08,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
