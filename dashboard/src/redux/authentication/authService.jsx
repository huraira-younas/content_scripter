import axios from "axios";
import { baseUrl } from "../../routes/routes";

export const getStoredAdmin = () => {
  const storedAdmin =
    JSON.parse(localStorage.getItem("admin")) ||
    JSON.parse(sessionStorage.getItem("admin"));
  return storedAdmin;
};

export const loginApiCall = async (email, password) => {
  try {
    const response = await axios.post(
      `${baseUrl}/auth/api/login`,
      {
        email,
        password,
      },
      {
        headers: {
          Authorization: import.meta.env.VITE_ACCESS_TOKEN,
          "Content-Type": "application/json",
        },
      }
    );
    return response.data;
  } catch (error) {
    throw error;
  }
};
