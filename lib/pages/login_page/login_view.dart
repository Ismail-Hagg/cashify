import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/models/wallet_model.dart';
import 'package:cashify/pages/login_page/login_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/animeted_icon_widget.dart';
import 'package:cashify/widgets/avatar_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:cashify/widgets/titled_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_icons/icons8.dart';
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
    return PopScope(
      canPop: false,
      onPopInvoked: (val) => Get.find<LoginController>().backButton(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            return GetBuilder<LoginController>(
              init: Get.find<LoginController>(),
              builder: (controller) => GestureDetector(
                onTap: () => controller.dismissKeyboard(context),
                child: Stack(
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
                                height:
                                    controller.flip ? width * 1.4 : width * 1.1,
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
                                height:
                                    controller.flip ? width * 1.4 : width * 1.1,
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
                                            type: TextInputType.emailAddress,
                                            action: TextInputAction.next,
                                            node: controller
                                                .nodes[FieldType.email],
                                            active: controller
                                                    .active[FieldType.email]
                                                as bool,
                                            controller:
                                                controller.txtControllers[
                                                        FieldType.email]
                                                    as TextEditingController,
                                            title: 'email'.tr,
                                            titleSize: 12,
                                            titleColor: mainColor,
                                            width: width,
                                            textColor: mainColor,
                                          ),
                                          SizedBox(
                                            height: width * 0.04,
                                          ),
                                          TitledInput(
                                            obsFunc: () =>
                                                controller.obscurePass(),
                                            action: TextInputAction.done,
                                            node: controller
                                                .nodes[FieldType.password],
                                            active: controller
                                                    .active[FieldType.password]
                                                as bool,
                                            controller:
                                                controller.txtControllers[
                                                        FieldType.password]
                                                    as TextEditingController,
                                            password: true,
                                            obscurePass: controller.passCover,
                                            title: 'password'.tr,
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
                                                  text: 'forgot'.tr,
                                                  color: Colors.grey.shade500,
                                                  size: 12,
                                                ),
                                                onTap: () =>
                                                    controller.loginViews(
                                                        page: 3, noFlip: true),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: width * 0.05,
                                          ),
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: mainColor
                                                          .withOpacity(0.5),
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(1, 1))
                                                ],
                                              ),
                                              child: ButtonWidget(
                                                loading: controller.loginLoading
                                                    ? IconAnimated(
                                                        name: Icons8
                                                            .circles_menu_1_color,
                                                        controller: controller
                                                            .loadingController,
                                                        color: backgroundColor)
                                                    : null,
                                                width: width * 0.7,
                                                height: width * 0.1,
                                                textColor: backgroundColor,
                                                color: mainColor,
                                                isIos: authController.isIos,
                                                textSize: 22,
                                                type: ButtonType.raised,
                                                onClick: () =>
                                                    controller.emailLogin(
                                                        context: context),
                                                text: 'login'.tr,
                                              ),
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
                                                  text: 'or'.tr,
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
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    // google login
                                                    onTap: () =>
                                                        controller.googleLogin(
                                                            context: context),
                                                    child: Container(
                                                      height: width * 0.13,
                                                      width: width * 0.13,
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: shadowColor,
                                                            offset:
                                                                const Offset(
                                                                    0, 0),
                                                            blurRadius: 5,
                                                          ),
                                                        ],
                                                        color: forgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .google,
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
                                                                const Offset(
                                                                    0, 0),
                                                            blurRadius: 5,
                                                          )
                                                        ],
                                                        color: forgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .phone,
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
                                                                const Offset(
                                                                    0, 0),
                                                            blurRadius: 5,
                                                          )
                                                        ],
                                                        color: forgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .envelope,
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
                                                onTap: () => controller
                                                    .loginViews(page: 0),
                                                child: Container(
                                                  width: width * 0.07,
                                                  height: width * 0.07,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const FittedBox(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
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
                                                type: controller.picPath == ''
                                                    ? AvatarType.none
                                                    : AvatarType.local,
                                                height: width * 0.25,
                                                width: width * 0.25,
                                                link: controller.picPath,
                                                border: false,
                                              ),
                                              Positioned(
                                                bottom: 2,
                                                right: 2,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      controller.selectPic(),
                                                  child: Container(
                                                    width: width * 0.05,
                                                    height: width * 0.05,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: mainColor),
                                                    ),
                                                    child: Center(
                                                      child: FaIcon(
                                                        color: mainColor,
                                                        size: width * 0.035,
                                                        controller.picPath == ''
                                                            ? FontAwesomeIcons
                                                                .plus
                                                            : FontAwesomeIcons
                                                                .trashCan,
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
                                              action: TextInputAction.next,
                                              node: controller
                                                  .nodes[FieldType.username],
                                              active: controller.active[
                                                  FieldType.username] as bool,
                                              controller:
                                                  controller.txtControllers[
                                                          FieldType.username]
                                                      as TextEditingController,
                                              title: 'username'.tr,
                                              titleSize: width * 0.03,
                                              titleColor: mainColor,
                                              width: width,
                                              textColor: mainColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: TitledInput(
                                              type: TextInputType.emailAddress,
                                              action: TextInputAction.next,
                                              node: controller
                                                  .nodes[FieldType.email],
                                              active: controller
                                                      .active[FieldType.email]
                                                  as bool,
                                              controller:
                                                  controller.txtControllers[
                                                          FieldType.email]
                                                      as TextEditingController,
                                              title: 'email'.tr,
                                              titleSize: width * 0.03,
                                              titleColor: mainColor,
                                              width: width,
                                              textColor: mainColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: TitledInput(
                                              action: TextInputAction.done,
                                              node: controller
                                                  .nodes[FieldType.password],
                                              active: controller.active[
                                                  FieldType.password] as bool,
                                              controller:
                                                  controller.txtControllers[
                                                          FieldType.password]
                                                      as TextEditingController,
                                              title: 'password'.tr,
                                              titleSize: width * 0.03,
                                              titleColor: mainColor,
                                              width: width,
                                              textColor: mainColor,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 5,
                                                    color: mainColor
                                                        .withOpacity(0.5),
                                                    offset: const Offset(1, 1))
                                              ],
                                            ),
                                            child: ButtonWidget(
                                                loading: controller.loginLoading
                                                    ? IconAnimated(
                                                        name: Icons8
                                                            .circles_menu_1_color,
                                                        controller: controller
                                                            .loadingController,
                                                        color: backgroundColor)
                                                    : null,
                                                width: width * 0.6,
                                                height: width * 0.12,
                                                isIos: false,
                                                textSize: width * 0.06,
                                                type: ButtonType.raised,
                                                color: mainColor,
                                                onClick: () =>
                                                    controller.emailSignup(
                                                        context: context),
                                                text: "signup".tr),
                                          )
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
                                                onTap: () => controller
                                                    .loginViews(page: 0),
                                                child: Container(
                                                  width: width * 0.07,
                                                  height: width * 0.07,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const FittedBox(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
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
                                                type: controller.picPath == ''
                                                    ? AvatarType.none
                                                    : AvatarType.local,
                                                height: width * 0.25,
                                                width: width * 0.25,
                                                link: controller.picPath,
                                                border: false,
                                              ),
                                              Positioned(
                                                bottom: 2,
                                                right: 2,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      controller.selectPic(),
                                                  child: Container(
                                                    width: width * 0.05,
                                                    height: width * 0.05,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: mainColor)),
                                                    child: Center(
                                                      child: FaIcon(
                                                        color: mainColor,
                                                        size: width * 0.035,
                                                        controller.picPath == ''
                                                            ? FontAwesomeIcons
                                                                .plus
                                                            : FontAwesomeIcons
                                                                .trashCan,
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
                                              action: TextInputAction.next,
                                              node: controller
                                                  .nodes[FieldType.username],
                                              active: controller.active[
                                                  FieldType.username] as bool,
                                              controller:
                                                  controller.txtControllers[
                                                          FieldType.username]
                                                      as TextEditingController,
                                              title: 'username'.tr,
                                              titleSize: width * 0.03,
                                              titleColor: mainColor,
                                              width: width,
                                              textColor: mainColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: TitledInput(
                                              active: controller
                                                      .active[FieldType.phone]
                                                  as bool,
                                              controller:
                                                  controller.txtControllers[
                                                          FieldType.phone]
                                                      as TextEditingController,
                                              title: 'phone'.tr,
                                              titleSize: width * 0.03,
                                              titleColor: mainColor,
                                              width: width,
                                              textColor: mainColor,
                                              otherInput:
                                                  InternationalPhoneNumberInput(
                                                keyboardAction:
                                                    TextInputAction.done,
                                                focusNode: controller
                                                    .nodes[FieldType.phone],
                                                textFieldController: controller
                                                            .txtControllers[
                                                        FieldType.phone]
                                                    as TextEditingController,
                                                isEnabled: true,
                                                initialValue: PhoneNumber(
                                                  isoCode: 'SA',
                                                ),
                                                inputDecoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                searchBoxDecoration:
                                                    const InputDecoration(),
                                                cursorColor: Colors.transparent,
                                                keyboardType:
                                                    TextInputType.number,
                                                selectorConfig: const SelectorConfig(
                                                    leadingPadding: 8,
                                                    useBottomSheetSafeArea:
                                                        true,
                                                    setSelectorButtonAsPrefixIcon:
                                                        true,
                                                    selectorType:
                                                        PhoneInputSelectorType
                                                            .BOTTOM_SHEET),
                                                onInputChanged: (onInputChanged) =>
                                                    controller.phoneController(
                                                        phone: onInputChanged
                                                            .phoneNumber
                                                            .toString()),
                                              ),
                                            ),
                                          ),
                                          if (controller.codeSent) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: TitledInput(
                                                controller:
                                                    TextEditingController(),
                                                otherHere: true,
                                                title: 'code'.tr,
                                                titleSize: width * 0.03,
                                                titleColor: mainColor,
                                                width: width,
                                                textColor: mainColor,
                                                active: true,
                                                otherInput: PinFieldAutoFill(
                                                  currentCode: controller
                                                      .txtControllers[
                                                          FieldType.otp]!
                                                      .text,
                                                  controller:
                                                      controller.txtControllers[
                                                          FieldType.otp],
                                                  autoFocus: false,
                                                  decoration:
                                                      BoxLooseDecoration(
                                                    textStyle: TextStyle(
                                                        color: mainColor),
                                                    strokeColorBuilder:
                                                        FixedColorBuilder(
                                                            mainColor),
                                                    bgColorBuilder:
                                                        FixedColorBuilder(Colors
                                                            .grey.shade200),
                                                  ),
                                                  onCodeChanged: (code) =>
                                                      controller.otpVerify(
                                                          context: context,
                                                          otp: code.toString()),
                                                  onCodeSubmitted: (code) {},
                                                ),
                                              ),
                                            ),
                                          ],
                                          const Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: shadowColor,
                                                    blurRadius: 5,
                                                    offset: const Offset(1, 1))
                                              ],
                                            ),
                                            child: ButtonWidget(
                                                loading: controller.loginLoading
                                                    ? IconAnimated(
                                                        name: Icons8
                                                            .circles_menu_1_color,
                                                        controller: controller
                                                            .loadingController,
                                                        color: backgroundColor)
                                                    : null,
                                                width: width * 0.6,
                                                height: width * 0.12,
                                                isIos: authController.isIos,
                                                textSize: width * 0.06,
                                                type: ButtonType.raised,
                                                color: mainColor,
                                                onClick: () =>
                                                    controller.phoneLogin(
                                                        context: context),
                                                text:
                                                    controller.verificationId ==
                                                            ''
                                                        ? 'signup'.tr
                                                        : 'code'.tr),
                                          )
                                        ],
                                      ),
                                    ),
                                    // reset password view - page 3
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24.0, horizontal: 12),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () =>
                                                    controller.loginViews(
                                                  page: 0,
                                                ),
                                                child: Container(
                                                  width: width * 0.07,
                                                  height: width * 0.07,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const FittedBox(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.xmark,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 32.0),
                                            child: TitledInput(
                                              node: controller
                                                  .nodes[FieldType.email],
                                              active: controller
                                                      .active[FieldType.email]
                                                  as bool,
                                              controller:
                                                  controller.txtControllers[
                                                          FieldType.email]
                                                      as TextEditingController,
                                              title: 'email'.tr,
                                              titleSize: width * 0.03,
                                              titleColor: mainColor,
                                              width: width,
                                              textColor: mainColor,
                                            ),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: shadowColor,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(1, 1))
                                                ],
                                              ),
                                              child: ButtonWidget(
                                                  width: width * 0.6,
                                                  height: width * 0.12,
                                                  isIos: authController.isIos,
                                                  textSize: width * 0.05,
                                                  type: ButtonType.raised,
                                                  color: mainColor,
                                                  onClick: () {},
                                                  text: "reset".tr),
                                            ),
                                          )
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
              ),
            );
          },
        ),
      ),
    );
  }
}
