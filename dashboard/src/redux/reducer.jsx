const initialState = {
  lang: "en",
  dir: "ltr",
  dataThemeMode: "light",
  dataMenuStyles: "dark",
  dataNavLayout: "vertical",
  dataHeaderStyles: "light",
  dataVerticalStyle: "overlay",
  StylebodyBg: "107 64 64",
  StyleDarkBg: "93 50 50",
  toggled: "",
  dataNavStyle: "",
  horStyle: "",
  dataPageStyle: "regular",
  dataWidth: "fullwidth",
  dataMenuPosition: "fixed",
  dataHeaderPosition: "fixed",
  loader: "disable",
  iconOverlay: "",
  colorPrimaryRgb: "",
  bodyBg1: "",
  bodyBg2: "",
  darkBg: "",
  inputBorder: "",
  bgImg: "",
  iconText: "",
  body: {
    class: "",
  },
  admin:
    JSON.parse(localStorage.getItem("admin")) ||
    JSON.parse(sessionStorage.getItem("admin")) ||
    {},
  authLoader: false,
  authStatus:
    !!JSON.parse(localStorage.getItem("admin")) ||
    !!JSON.parse(sessionStorage.getItem("admin")),
  authMessage: "",
  users: {},
  usersLoader: false,
  helpcenter: {},
  updateLoader: false,
  getLoader: false,
  onBoarding: [],
  updateOnBoardingLoader: false,
  deleteOnBoardingLoader: false,
  getOnBoardingLoader: false,
  assistant: [],
  updateAssistantLoader: false,
  getAssistantLoader: false,
  deleteAssistantLoader: false,
  prompt: {},
  promptLoader: false,
  promptGetLoader: false,
  membership: [],
  membershipGetLoader: false,
  membershipLoader: false,
  membershipTime: [],
  membershiTimeLoader: false,
  membershipTimeGetLoader: false,
  interest: [],
  interestLoader: false,
};
export default function reducer(state = initialState, action) {
  const { type, payload } = action;

  switch (type) {
    case "ThemeChanger":
      state = payload;
      return state;
      break;

    case "LOGIN_REQUEST":
      return {
        ...state,
        authLoader: true,
      };
    case "LOGIN_SUCCESS":
      return {
        ...state,
        authLoader: false,
        authStatus: true,
        admin: payload,
      };
    case "LOGIN_FAILURE":
      return {
        ...state,
        authLoader: false,
        authMessage: payload,
      };
    case "LOGOUT":
      localStorage.removeItem("admin");
      sessionStorage.removeItem("admin");
      return {
        ...state,
        admin: {},
        authStatus: false,
      };
    case "USERS_REQUEST":
      return {
        ...state,
        usersLoader: true,
      };
    case "USERS_SUCCESS":
      return {
        ...state,
        usersLoader: false,
        users: payload,
      };
    case "USERS_FAILURE":
      return {
        ...state,
        usersLoader: false,
      };
    case "ADD_HELPCENTER_REQUEST":
      return {
        ...state,
        updateLoader: true,
      };
    case "ADD_HELPCENTER_SUCCESS":
      return {
        ...state,
        updateLoader: false,
        helpcenter: payload,
      };
    case "ADD_HELPCENTER_FAILURE":
      return {
        ...state,
        updateLoader: false,
      };
    case "GET_HELPCENTER_REQUEST":
      return {
        ...state,
        getLoader: true,
      };
    case "GET_HELPCENTER_SUCCESS":
      return {
        ...state,
        getLoader: false,
        helpcenter: payload,
      };
    case "GET_HELPCENTER_FAILURE":
      return {
        ...state,
        getLoader: false,
      };
    case "UPDATE_HELPCENTER_REQUEST":
      return {
        ...state,
        updateLoader: true,
      };
    case "UPDATE_HELPCENTER_SUCCESS":
      return {
        ...state,
        updateLoader: false,
        helpcenter: payload,
      };
    case "UPDATE_HELPCENTER_FAILURE":
      return {
        ...state,
        updateLoader: false,
      };
    case "DELETE_HELPCENTER_REQUEST":
      return {
        ...state,
        updateLoader: true,
      };
    case "DELETE_HELPCENTER_SUCCESS":
      return {
        ...state,
        updateLoader: false,
        helpcenter: payload,
      };
    case "DELETE_HELPCENTER_FAILURE":
      return {
        ...state,
        updateLoader: false,
      };
    //! ONBOARDING   /////
    case "ADD_ONBOARDING_REQUEST":
      return {
        ...state,
        updateOnBoardingLoader: true,
      };
    case "ADD_ONBOARDING_SUCCESS":
      return {
        ...state,
        updateOnBoardingLoader: false,
        onBoarding: payload,
      };
    case "ADD_ONBOARDING_FAILURE":
      return {
        ...state,
        updateOnBoardingLoader: false,
      };
    case "UPDATE_ONBOARDING_REQUEST":
      return {
        ...state,
        updateOnBoardingLoader: true,
      };
    case "UPDATE_ONBOARDING_SUCCESS":
      return {
        ...state,
        updateOnBoardingLoader: false,
        onBoarding: payload,
      };
    case "UPDATE_ONBOARDING_FAILURE":
      return {
        ...state,
        updateOnBoardingLoader: false,
      };
    case "DELETE_ONBOARDING_REQUEST":
      return {
        ...state,
        deleteOnBoardingLoader: true,
      };
    case "DELETE_ONBOARDING_SUCCESS":
      return {
        ...state,
        deleteOnBoardingLoader: false,
        onBoarding: payload,
      };
    case "DELETE_ONBOARDING_FAILURE":
      return {
        ...state,
        deleteOnBoardingLoader: false,
      };
    case "GET_ONBOARDING_REQUEST":
      return {
        ...state,
        getOnBoardingLoader: true,
      };
    case "GET_ONBOARDING_SUCCESS":
      return {
        ...state,
        getOnBoardingLoader: false,
        onBoarding: payload,
      };
    case "GET_ONBOARDING_FAILURE":
      return {
        ...state,
        getOnBoardingLoader: false,
      };
    //! MEMBERSHIP   /////
    case "GET_MEMBERSHIP_REQUEST":
      return {
        ...state,
        membershipGetLoader: true,
      };
    case "GET_MEMBERSHIP_SUCCESS":
      return {
        ...state,
        membershipGetLoader: false,
        membership: payload,
      };
    case "GET_MEMBERSHIP_FAILURE":
      return {
        ...state,
        membershipGetLoader: false,
      };
    case "ADD_MEMBERSHIP_REQUEST":
      return {
        ...state,
        membershipLoader: true,
      };
    case "ADD_MEMBERSHIP_SUCCESS":
      return {
        ...state,
        membershipLoader: false,
        membership: payload,
      };
    case "ADD_MEMBERSHIP_FAILURE":
      return {
        ...state,
        membershipLoader: false,
      };
    case "UPDATE_MEMBERSHIP_REQUEST":
      return {
        ...state,
        membershipLoader: true,
      };
    case "UPDATE_MEMBERSHIP_SUCCESS":
      return {
        ...state,
        membershipLoader: false,
        membership: payload,
      };
    case "UPDATE_MEMBERSHIP_FAILURE":
      return {
        ...state,
        membershipLoader: false,
      };
    case "DELETE_MEMBERSHIP_REQUEST":
      return {
        ...state,
        membershipLoader: true,
      };
    case "DELETE_MEMBERSHIP_SUCCESS":
      return {
        ...state,
        membershipLoader: false,
        membership: payload,
      };
    case "DELETE_MEMBERSHIP_FAILURE":
      return {
        ...state,
        membershipLoader: false,
      };

    case "GET_MEMBERSHIPTIME_REQUEST":
      return {
        ...state,
        membershipTimeGetLoader: true,
      };
    case "GET_MEMBERSHIPTIME_SUCCESS":
      return {
        ...state,
        membershipTimeGetLoader: false,
        membershipTime: payload,
      };
    case "GET_MEMBERSHIPTIME_FAILURE":
      return {
        ...state,
        membershipTimeGetLoader: false,
      };

    case "UPDATE_MEMBERSHIPTIME_REQUEST":
      return {
        ...state,
        membershiTimeLoader: true,
      };
    case "UPDATE_MEMBERSHIPTIME_SUCCESS":
      return {
        ...state,
        membershipTimeLoader: false,
        membershipTime: payload,
      };
    case "UPDATE_MEMBERSHIPTIME_FAILURE":
      return {
        ...state,
        membershipTimeLoader: false,
      };
    //! ASSISTANT //

    case "ADD_ASSISTANT_REQUEST":
      return {
        ...state,
        updateAssistantLoader: true,
      };
    case "ADD_ASSISTANT_SUCCESS":
      return {
        ...state,
        updateAssistantLoader: false,
        assistant: payload,
      };
    case "ADD_ASSISTANT_FAILURE":
      return {
        ...state,
        updateAssistantLoader: false,
      };
    case "UPDATE_ASSISTANT_REQUEST":
      return {
        ...state,
        updateAssistantLoader: true,
      };
    case "UPDATE_ASSISTANT_SUCCESS":
      return {
        ...state,
        updateAssistantLoader: false,
        assistant: payload,
      };
    case "UPDATE_ASSISTANT_FAILURE":
      return {
        ...state,
        updateAssistantLoader: false,
      };
    case "DELETE_ASSISTANT_REQUEST":
      return {
        ...state,
        deleteAssistantLoader: true,
      };
    case "DELETE_ASSISTANT_SUCCESS":
      return {
        ...state,
        deleteAssistantLoader: false,
        assistant: payload,
      };
    case "DELETE_ASSISTANT_FAILURE":
      return {
        ...state,
        deleteAssistantLoader: false,
      };
    case "GET_ASSISTANT_REQUEST":
      return {
        ...state,
        getAssistantLoader: true,
      };
    case "GET_ASSISTANT_SUCCESS":
      return {
        ...state,
        getAssistantLoader: false,
        assistant: payload,
      };
    case "GET_ASSISTANT_FAILURE":
      return {
        ...state,
        getAssistantLoader: false,
      };

    //! RESTRICTION   /////

    case "ADD_PROMPT_REQUEST":
      return {
        ...state,
        promptLoader: true,
      };
    case "ADD_PROMPT_SUCCESS":
      return {
        ...state,
        promptLoader: false,
        prompt: payload,
      };
    case "ADD_PROMPT_FAILURE":
      return {
        ...state,
        promptLoader: false,
      };
    case "GET_PROMPT_REQUEST":
      return {
        ...state,
        promptGetLoader: true,
      };
    case "GET_PROMPT_SUCCESS":
      return {
        ...state,
        promptGetLoader: false,
        prompt: payload,
      };
    case "GET_PROMPT_FAILURE":
      return {
        ...state,
        promptGetLoader: false,
      };
    case "UPDATE_PROMPT_REQUEST":
      return {
        ...state,
        promptLoader: true,
      };
    case "UPDATE_PROMPT_SUCCESS":
      return {
        ...state,
        promptLoader: false,
        prompt: payload,
      };
    case "UPDATE_PROMPT_FAILURE":
      return {
        ...state,
        promptLoader: false,
      };
    default:
      return state;
  }
}
