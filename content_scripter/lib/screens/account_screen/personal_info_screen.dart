import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/blocs/timer_bloc/timer_bloc.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart';
import 'package:content_scripter/common_widget/profile_avt.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:content_scripter/models/user_model.dart';
import 'package:content_scripter/cubits/otp_cubit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalInfoScreen extends StatefulWidget {
  final UserModel user;
  const PersonalInfoScreen({super.key, required this.user});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final _userBloc = context.read<UserBloc>();
  final _controllers = List.generate(4, (index) => TextEditingController());
  final _keys = List.generate(3, (index) => GlobalKey<FormState>());
  final _loader = LoadingScreen.instance();
  final _otpKey = GlobalKey<FormState>();

  late UserModel user;
  late String _profile;
  bool otp = false;
  Country? _country;
  bool _isValidOtp = true, _isEmail = false, _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: customAppBar(context: context),
        body: MultiBlocListener(
          listeners: [
            BlocListener<OtpCubit, OtpState>(listener: (context, state) {
              _loader.hide();
              switch (state.event) {
                case OtpEvent.error:
                  showError(state.title, state.message);
                  return;
                case OtpEvent.sending:
                  _loader.show(
                    context: context,
                    title: state.title,
                    text: state.message,
                  );
                  return;
                default:
                  setState(() => otp = true);
                  BlocProvider.of<TimerBloc>(context).add(StartTimer(
                    duration: 60,
                  ));
                  Fluttertoast.showToast(msg: state.message);
              }
            }),
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state.loading == null && state.error == null) {
                  user = _userBloc.user!;
                  Fluttertoast.showToast(msg: "Profile Updated");
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.padding + 6),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.04),
                Center(
                  child: Stack(
                    children: [
                      Hero(
                        tag: user.uid,
                        child: ProfileAvt(
                          size: 140,
                          iconSize: 80,
                          url: _profile,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera, size: 30),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _keys[0],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.person),
                    type: TextInputType.emailAddress,
                    onChange: (v) => handleChange(),
                    label: "Name",
                    hint: "Enter Name",
                    controller: _controllers[0],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Name";
                      }
                      return value.trim().length < 4
                          ? "Name length must be at least 4 characters"
                          : null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _keys[1],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.email),
                    label: "Email",
                    hint: "Enter Email",
                    type: TextInputType.emailAddress,
                    controller: _controllers[1],
                    onChange: (_) => handleChange(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Email";
                      }
                      return !AppUtils.isEmail(value)
                          ? "Invalid email address"
                          : null;
                    },
                    suffixIcon: BlocBuilder<TimerBloc, TimerState>(
                      builder: (context, state) {
                        if (state is TimerStopped) {
                          return IconButton(
                            onPressed: _isEmail ? () => sentOTP() : null,
                            icon: Icon(
                              Icons.send,
                              color: _isEmail ? AppColors.primaryColor : null,
                            ),
                          );
                        } else if (state is TickingTimer) {
                          final minutes = ((state.duration / 60) % 60)
                              .floor()
                              .toString()
                              .padLeft(2, '0');
                          final seconds = (state.duration % 60)
                              .floor()
                              .toString()
                              .padLeft(2, '0');
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 30,
                            child: Center(
                              child: MyText(
                                text: '$minutes:$seconds',
                                color: AppColors.primaryColor,
                                family: AppFonts.medium,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: AnimatedContainer(
                        height: state is TickingTimer ? 0 : 24,
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.only(left: 14.0, top: 6),
                        child: const MyText(
                          text: "Click on arrow to get OTP",
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(),
                  clipBehavior: Clip.antiAlias,
                  margin:
                      EdgeInsets.only(bottom: !otp || _isValidOtp ? 0.0 : 10),
                  height: !otp
                      ? 0.0
                      : _isValidOtp
                          ? 90
                          : 108,
                  child: Form(
                    key: _otpKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: CustomTextField(
                      prefixIcon: const Icon(Icons.lock),
                      onChange: (p0) {
                        setState(
                            () => _isValidOtp = p0 != null && p0.isNotEmpty);
                      },
                      type: TextInputType.phone,
                      hint: "Enter OTP",
                      label: "OTP",
                      border: otp ? null : InputBorder.none,
                      controller: _controllers[2],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Required otp";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Form(
                  key: _keys[2],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    type: TextInputType.phone,
                    onChange: (v) => handleChange(),
                    prefixIcon: TextButton(
                      onPressed: () => _buildCountryPicker(
                        context,
                        (country) {
                          _country = country;
                          handleChange();
                        },
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 8),
                          MyText(
                            text: "+${_country?.phoneCode ?? '1'}",
                            size: AppConstants.subtitle,
                            color: _country != null
                                ? Colors.white
                                : AppColors.greyColor,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: _country != null
                                ? Colors.white
                                : AppColors.greyColor,
                          ),
                        ],
                      ),
                    ),
                    label: "Phone Number",
                    hint: "Enter Phone Number",
                    controller: _controllers[3],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Phone Number";
                      }
                      if (_country == null) {
                        return "Required Phone Code";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: "Save",
                    onPressed: _isEditing ? updateUser : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateUser() {
    FocusScope.of(context).unfocus();
    if (_keys.any((e) => !e.currentState!.validate())) {
      return;
    }

    if (otp && !_otpKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please enter the OTP");
      return;
    }

    final name = _controllers[0].text.trim();
    final phone = _controllers[3].text.trim();
    final email = _controllers[1].text.trim().toLowerCase();

    _userBloc.add(UpdateUserEvent(
      newEmail: email,
      user: user.copyWith(
          name: name,
          email: user.email,
          profileUrl: _profile,
          phone: user.phone.copyWith(
            number: phone,
            country: _country!.name,
            code: _country!.countryCode,
            phoneCode: _country!.phoneCode,
          )),
    ));
  }

  void handleChange() async {
    final name = _controllers[0].text.trim();
    final phone = _controllers[3].text.trim();
    final email = _controllers[1].text.trim();

    _isEmail = _keys[1].currentState!.validate() && user.email != email;

    final editing = name != user.name ||
        email != user.email ||
        phone != user.phone.number ||
        _profile != user.profileUrl ||
        _country!.countryCode != user.phone.code;

    setState(() => _isEditing = editing);
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    final phone = user.phone;
    _controllers[0].text = user.name;
    _controllers[1].text = user.email;
    _controllers[3].text = phone.number;
    _profile = user.profileUrl;
    _country = CountryService().findByCode(phone.code);
  }

  @override
  void dispose() {
    _controllers.asMap().forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  void sentOTP() {
    FocusScope.of(context).unfocus();
    final email = _controllers[1].text.trim();
    context.read<OtpCubit>().sendOtp(email: email);
  }

  void _pickImage() async {
    final image = await AppUtils.pickImage(isCamera: false);
    if (image == null) {
      Fluttertoast.showToast(msg: "Couldn't pick image");
      return;
    }
    _profile = image.path;
    handleChange();
  }

  void showError(String title, String message) => errorDialogue(
        context: context,
        title: title,
        message: message,
      );
}

void _buildCountryPicker(BuildContext context, Function(Country) onSelect) {
  showCountryPicker(
    showPhoneCode: true,
    context: context,
    countryListTheme: CountryListThemeData(
      flagSize: 20,
      backgroundColor: AppColors.secondaryColor,
      textStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontSize: 16,
      ),
      searchTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
      bottomSheetHeight: 500,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      inputDecoration: customInputDecoration(
        hint: "Start typing to search...",
        prefixIcon: const Icon(Icons.search, color: Colors.white),
      ),
    ),
    onSelect: onSelect,
  );
}
