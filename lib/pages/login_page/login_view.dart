import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/pages/login_page/login_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/avatar_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:cashify/widgets/titled_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    GloableAuthController authController = Get.find<GloableAuthController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          return GetBuilder<LoginController>(
            init: Get.find<LoginController>(),
            builder: (controller) => Stack(
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
                        child: Column(
                          children: [
                            SizedBox(
                              height: width * 0.13,
                            ),
                            SafeArea(
                              child: CustomText(
                                spacing: 5,
                                text: 'CASHIFY',
                                color: backgroundColor,
                                size: width * 0.1,
                              )
                                  .animate(
                                      onPlay: (controller) =>
                                          controller.repeat())
                                  .shimmer(
                                      duration: const Duration(seconds: 5),
                                      color: secondaryColor),
                            )
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
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: controller.flip ? width * 1.4 : width * 1.1,
                            width: width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor,
                                  offset: const Offset(0, 0),
                                  blurRadius: 7,
                                )
                              ],
                              color: forgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            height: controller.flip ? width * 1.4 : width * 1.1,
                            width: width,
                            child: PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: controller.pageController,
                              children: [
                                // main login view - page 0
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0, horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TitledInput(
                                        node: controller.focus,
                                        active: controller.fuck,
                                        title: 'Email Adress',
                                        titleSize: 12,
                                        titleColor: mainColor,
                                        width: width,
                                        textColor: mainColor,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                          isIos: authController.isIos,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                horizontal:
                                                    (width * 0.7) * 0.025),
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
                                              GestureDetector(
                                                // google login
                                                onTap: () {},
                                                child: Container(
                                                  height: width * 0.13,
                                                  width: width * 0.13,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadowColor,
                                                        offset:
                                                            const Offset(0, 0),
                                                        blurRadius: 5,
                                                      ),
                                                    ],
                                                    color: forgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons.google,
                                                      color: mainColor,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => controller
                                                    .loginViews(page: 2),
                                                child: Container(
                                                  height: width * 0.13,
                                                  width: width * 0.13,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadowColor,
                                                        offset:
                                                            const Offset(0, 0),
                                                        blurRadius: 5,
                                                      )
                                                    ],
                                                    color: forgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons.phone,
                                                      color: mainColor,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => controller
                                                    .loginViews(page: 1),
                                                child: Container(
                                                  height: width * 0.13,
                                                  width: width * 0.13,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadowColor,
                                                        offset:
                                                            const Offset(0, 0),
                                                        blurRadius: 5,
                                                      )
                                                    ],
                                                    color: forgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons.envelope,
                                                      color: mainColor,
                                                      size: width * 0.08,
                                                    ),
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

                                // email signup view - page 1
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 12),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                controller.loginViews(page: 0),
                                            child: Container(
                                              width: width * 0.07,
                                              height: width * 0.07,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const FittedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons.xmark,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Avatar(
                                            shadow: true,
                                            type: AvatarType.none,
                                            height: width * 0.2,
                                            width: width * 0.2,
                                            link:
                                                'https://www.jesusfreakhideout.com/news/2019/01/pics/torikellyacoustictour.jpg',
                                            border: false,
                                          ),
                                          Positioned(
                                            bottom: 2,
                                            right: 2,
                                            child: GestureDetector(
                                              onTap: () {
                                                print('object');
                                              },
                                              child: Container(
                                                width: width * 0.05,
                                                height: width * 0.05,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: mainColor)),
                                                child: const FittedBox(
                                                  child: FaIcon(
                                                    FontAwesomeIcons.plus,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: TitledInput(
                                            title: 'Username',
                                            titleSize: width * 0.03,
                                            titleColor: mainColor,
                                            width: width,
                                            textColor: mainColor,
                                            active: true),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: TitledInput(
                                            title: 'Email Adress',
                                            titleSize: width * 0.03,
                                            titleColor: mainColor,
                                            width: width,
                                            textColor: mainColor,
                                            active: true),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: TitledInput(
                                            title: 'Password',
                                            titleSize: width * 0.03,
                                            titleColor: mainColor,
                                            width: width,
                                            textColor: mainColor,
                                            active: true),
                                      ),
                                      const Spacer(),
                                      ButtonWidget(
                                          width: width * 0.6,
                                          height: width * 0.12,
                                          isIos: false,
                                          textSize: width * 0.06,
                                          type: ButtonType.raised,
                                          color: mainColor,
                                          onClick: () {},
                                          text: "Signup")
                                    ],
                                  ),
                                ),
                                // phone signup view - page 2
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0, horizontal: 12),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                controller.loginViews(page: 0),
                                            child: Container(
                                              width: width * 0.07,
                                              height: width * 0.07,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const FittedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons.xmark,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Avatar(
                                            shadow: true,
                                            type: AvatarType.none,
                                            height: width * 0.2,
                                            width: width * 0.2,
                                            link:
                                                'https://www.jesusfreakhideout.com/news/2019/01/pics/torikellyacoustictour.jpg',
                                            border: false,
                                          ),
                                          Positioned(
                                            bottom: 2,
                                            right: 2,
                                            child: GestureDetector(
                                              //onTap: () => controller.flip(page:0),
                                              child: Container(
                                                width: width * 0.05,
                                                height: width * 0.05,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: mainColor)),
                                                child: const FittedBox(
                                                  child: FaIcon(
                                                    FontAwesomeIcons.plus,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: TitledInput(
                                            title: 'Username',
                                            titleSize: width * 0.03,
                                            titleColor: mainColor,
                                            width: width,
                                            textColor: mainColor,
                                            active: true),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: TitledInput(
                                          title: 'Phone Numbeer',
                                          titleSize: width * 0.03,
                                          titleColor: mainColor,
                                          width: width,
                                          textColor: mainColor,
                                          active: true,
                                          otherInput:
                                              InternationalPhoneNumberInput(
                                            isEnabled: true,
                                            initialValue: PhoneNumber(
                                              isoCode: 'SA',
                                            ),
                                            inputDecoration:
                                                const InputDecoration(
                                                    border: InputBorder.none),
                                            searchBoxDecoration:
                                                const InputDecoration(),
                                            cursorColor: Colors.transparent,
                                            keyboardType: TextInputType.number,
                                            selectorConfig: const SelectorConfig(
                                                leadingPadding: 8,
                                                useBottomSheetSafeArea: true,
                                                setSelectorButtonAsPrefixIcon:
                                                    true,
                                                selectorType:
                                                    PhoneInputSelectorType
                                                        .BOTTOM_SHEET),
                                            onInputChanged: (onInputChanged) {},
                                          ),
                                        ),
                                      ),
                                      if (controller.codeSent) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: TitledInput(
                                            otherHere: true,
                                            title: 'Enter the code',
                                            titleSize: width * 0.03,
                                            titleColor: mainColor,
                                            width: width,
                                            textColor: mainColor,
                                            active: true,
                                            otherInput: PinFieldAutoFill(
                                                //controller: controller.otpController,
                                                autoFocus: false,
                                                decoration: BoxLooseDecoration(
                                                    textStyle: TextStyle(
                                                        color: mainColor),
                                                    strokeColorBuilder:
                                                        FixedColorBuilder(
                                                            mainColor),
                                                    bgColorBuilder:
                                                        FixedColorBuilder(Colors
                                                            .grey.shade200)),
                                                // currentCode:
                                                //     controller.otpController.text,
                                                onCodeSubmitted: (code) {
                                                  print(code);
                                                },
                                                onCodeChanged: (code) {}
                                                //     controller.onPtpChanged(
                                                //   code: code,
                                                //   context: context,
                                                //   verificationId: verificationId,
                                                // ),
                                                ),
                                          ),
                                        ),
                                      ],
                                      const Spacer(),
                                      ButtonWidget(
                                          width: width * 0.6,
                                          height: width * 0.12,
                                          isIos: false,
                                          textSize: width * 0.06,
                                          type: ButtonType.raised,
                                          color: mainColor,
                                          onClick: () {},
                                          text: "Signup")
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
