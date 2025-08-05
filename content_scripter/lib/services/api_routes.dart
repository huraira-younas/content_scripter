import 'package:flutter/foundation.dart' show kDebugMode;

class ApiRoutes {
  static const koyebIp = "https://cs.hurairayounas.com/v1";
  static const localIp = "http://192.168.1.8:3000/v1";
  static const ip = kDebugMode ? localIp : koyebIp;

  static const _s3file = "https://veedo.altervista.org/wp-content/media/veedo";
  static const uploadFile = "$_s3file/upload.php";
  static const deleteFile = "$_s3file/delete.php";

  static const _auth = "$ip/auth/api";
  static const login = "$_auth/login";
  static const signup = "$_auth/signup";
  static const sendOtp = "$_auth/send_otp";
  static const verifyOtp = "$_auth/verify_otp";
  static const getFeature = "$_auth/get_feature";
  static const updateUser = "$_auth/update_user";
  static const updatePassword = "$_auth/update_password";

  static const _assistant = "$ip/assistant/api";
  static const getAllAssistants = "$_assistant/get_all";

  static const _history = "$ip/history/api";
  static const addHistory = "$_history/add";
  static const getHistory = "$_history/get";
  static const deleteHistory = "$_history/delete";
  static const updateHistory = "$_history/update";
  static const addSharedUser = "$_history/add_user";
  static const deleteAllHistory = "$_history/delete_all";

  static const _message = "$ip/message/api";
  static const addMessage = "$_message/add";
  static const getAllMessage = "$_message/get";
  static const deleteAllMessages = "$_message/delete_all";

  static const _onBoarding = "$ip/on_boarding/api";
  static const getAllPages = "$_onBoarding/get_all";

  static const _promptModel = "$ip/prompt/api";
  static const getPrompts = "$_promptModel/get_all";

  static const _helpCenter = "$ip/help_center/api";
  static const getHelpCenter = "$_helpCenter/get_all";

  static const _trends = "$ip/trends/api";
  static const getInterest = "$_trends/fetch_interest";
  static const getTrends = "$_trends/fetch_trends";

  static const _membership = "$ip/membership";
  static const getAllMemberships = "${_membership}_plan/api/get_all";
  static const getMembershipPeriod = "${_membership}_time/api/get_all";
  static const purchasePlan = "${_membership}_history/api/add_membership";
  static const cancelPlan = "${_membership}_history/api/cancel_membership";
  static const getPlanFeatures = "${_membership}_history/api/get_features";
  static const updatePlanFeature =
      "${_membership}_history/api/update_plan_feature";
}
