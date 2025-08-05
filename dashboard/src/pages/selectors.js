export const selectAdmin = (state) => state.admin;
export const selectAuthStatus = (state) => state.authStatus;
export const selectAuthLoader = (state) => state.authLoader;
export const selectAuthMessage = (state) => state.authMessage;

export const selectUsers = (state) => state.users;
export const selectUsersLoader = (state) => state.usersLoader;

export const selectGetLoader = (state) => state.getLoader;
export const selectHelpCenter = (state) => state.helpcenter;
export const selectUpdateLoader = (state) => state.updateLoader;

export const selectOnBoarding = (state) => state.onBoarding;
export const selectUpdateOnboardingLoader = (state) =>
  state.updateOnBoardingLoader;
export const selectOnboardingLoader = (state) => state.getOnBoardingLoader;
export const selectDeleteOnboardingLoader = (state) =>
  state.deleteOnBoardingLoader;
export const selectAssistant = (state) => state.assistant;
export const selectUpdateAssistantLoader = (state) =>
  state.updateAssistantLoader;
export const selectAssistantLoader = (state) => state.getAssistantLoader;
export const selectDeleteAssistantLoader = (state) =>
  state.deleteAssistantLoader;

export const selectPrompt = (state) => state.prompt;
export const selectPromptLoader = (state) => state.promptLoader;
export const selectPromptGetLoader = (state) => state.promptGetLoader;

export const selectMembership = (state) => state.membership;
export const selectMembershipGetLoader = (state) => state.membershipGetLoader;
export const selectMembershipLoader = (state) => state.membershipLoader;

export const selectMembershipTime = (state) => state.membershipTime;
export const selectMembershipTimeGetLoader = (state) =>
  state.membershipTimeGetLoader;
export const selectMembershipTimeLoader = (state) => state.membershipTimeLoader;
export const selectInterest = (state) => state.interest;
export const selectInterestLoader = (state) => state.interestLoader;
