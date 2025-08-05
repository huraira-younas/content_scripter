class AppConstants {
  static const appname = "Content Scripter";

  static const userPromptsKey = "userPrompts";
  static const promptTimerKey = "promptsKey";
  static const fileTimerKey = "fileKey";
  static const userPrefKey = "userPref";

  static const internalError =
      "An internal error occurred, please try to prompt again";

  static const unknownError = "An unknown error occurred, please try again";

  static const sharedHistoryText =
      "Enter a valid user email to share the history with them. User will be able to read messages and engage with the $appname";

  static const resetPassText =
      "Please enter your email and we will send on OTP code in the next step to reset your password.";

  static const createPassText =
      "Create your new password if you forget it, then you have to do forgot password";

  static const delHistoryText =
      "This will delete all your history and its not reversible. Do you really want to delete?";

  static const startChatText =
      "Start chatting with $appname now. You can ask me anything.";

  static const userPrefPrompt =
      "Below is user preference with the {catergory: frequency} how much user has liked a specific catergory\nHere are user preferences: ";

  static const promptsGenerator =
      "Generate some list of 4-8 example 8 words prompts (starts with a cool emoji) that user can ask you. Note: Your response must be in pure List<String> format. Any deviation will result in a penalty.";

  static const tagsApiKey = 'AIzaSyBwuW1R_06rUfbEn5ANvRQ-R0UczJ_auUY';
  static const titleLarge = 19.0;
  static const subtitle = 15.0;
  static const padding = 20.0;
  static const title = 17.0;
  static const text = 13.0;
}
