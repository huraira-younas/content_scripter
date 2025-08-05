export const baseUrl = "https://cs.hurairayounas.com/v1";

//! auth
export const LOGIN = `${baseUrl}/auth/api/login`;

//! helpcenter
export const GET_HELPCENTER = `${baseUrl}/help_center/api/get_all`;
export const UPDATE_HELPCENTER = `${baseUrl}/help_center/api/update`;

//! users
export const GET_USERS = `${baseUrl}/auth/api/get_all_users/users`;

//! on-boarding
export const ADD_ONBOARDING = `${baseUrl}/on_boarding/api/add`;
export const GET_ONBOARDING = `${baseUrl}/on_boarding/api/get_all`;
export const GET_ONBOARDING_BYID = `${baseUrl}/on_boarding/api/get`;
export const UPDATE_ONBOARDING = `${baseUrl}/on_boarding/api/update`;
export const DELETE_ONBOARDING = `${baseUrl}/on_boarding/api/delete`;

//! on-boarding
export const ADD_ASSISTANT = `${baseUrl}/assistant/api/add`;
export const GET_ASSISTANT = `${baseUrl}/assistant/api/get_all`;
export const GET_ASSISTANT_BYID = `${baseUrl}/assistant/api/get`;
export const UPDATE_ASSISTANT = `${baseUrl}/assistant/api/update`;
export const DELETE_ASSISTANT = `${baseUrl}/assistant/api/delete`;

//! memberships
export const GET_MEMBERSHIP = `${baseUrl}/membership_plan/api/get_all`;
export const GET_MEMBERSHIP_BYID = `${baseUrl}/membership_plan/api/get`;
export const ADD_MEMBERSHIP = `${baseUrl}/membership_plan/api/add`;
export const UPDATE_MEMBERSHIP = `${baseUrl}/membership_plan/api/update`;
export const DELETE_MEMBERSHIP = `${baseUrl}/membership_plan/api/delete`;

//! memberships Time
export const GET_MEMBERSHIP_TIME = `${baseUrl}/membership_time/api/get_all`;
export const UPDATE_MEMBERSHIP_TIME = `${baseUrl}/membership_time/api/update`;

//! prompt
export const ADD_PROMPT = `${baseUrl}/prompt/api/add`;
export const GET_PROMPT = `${baseUrl}/prompt/api/get_all`;
export const UPDATE_PROMPT = `${baseUrl}/prompt/api/update`;

//! files upload
export const FILES_UPLOAD = `https://essential-lorie-brain-f176e41d.koyeb.app/s3_file/api/upload_file`;
//! files delete
export const FILES_DELETE = `https://essential-lorie-brain-f176e41d.koyeb.app/s3_file/api/delete_file`;
