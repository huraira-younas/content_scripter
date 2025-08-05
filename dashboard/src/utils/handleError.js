import { toast } from "react-toastify";

export const handleError = (error) => {
  if (error.message === "Not Authorized") {
    return "Not Authorized";
  } else if (error?.response?.status > 200 && error?.response?.status < 500) {
    return error.response?.data.error;
  } else if (error?.response?.status === 500) {
    return error?.response?.statusText || "internal server error";
  }
};

export const toaster = ({ success, error }) => {
  if (success) {
    toast.success(success, { theme: "colored" });
  } else if (error) {
    toast.error(handleError(error), { theme: "colored" });
  }
};
