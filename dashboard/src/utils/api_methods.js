import { handleError } from "./handleError";
import { toast } from "react-toastify";
import axios from "axios";

export const postApi = async ({ url, login = false, credentials = {} }) => {
  try {
    const response = await axios.post(url, credentials, {
      headers: {
        "Content-Type": "application/json",
        Authorization: "senpai",
      },
    });

    if (response.status === 200) {
      if (login) {
        if (response.data.user.status !== "admin") {
          throw new Error("Not Authorized");
        } else {
          return response.data.user;
        }
      } else {
        return response.data;
      }
    }
  } catch (error) {
    console.log(error);
    throw error;
  }
};

export const getApi = async ({ url }) => {
  try {
    const response = await axios.get(`${url}`, {
      headers: { Authorization: "senpai" },
    });
    if (response.status === 200) {
      return response.data;
    }
  } catch (error) {
    throw error;
  }
};

export const getUsersApi = async ({ credentials, url }) => {
  try {
    const { signal, search } = credentials;

    const response = await axios.get(`${url}${search}`, {
      headers: { Authorization: "senpai" },
      signal: signal,
    });
    if (response.status === 200) {
      return response.data;
    }
  } catch (error) {
    throw error;
  }
};
export const getByIdApi = async ({ url, credentials, isDelete = false }) => {
  try {
    const response = await axios.get(`${url}/${credentials}`, {
      headers: {
        "Content-Type": "application/json",
        Authorization: "senpai",
      },
    });

    if (response.status === 200) {
      if (isDelete) {
        return toast.success(response.data.message || response.data, {
          theme: "colored",
        });
      } else {
        return response.data;
      }
    }
  } catch (error) {
    throw error;
  }
};

export const getById = async ({ url }) => {
  try {
    const response = await axios.get(`${url}`, {
      headers: {
        "Content-Type": "application/json",
        Authorization: "senpai",
      },
    });
    if (response.status === 200) {
      return response.data;
    }
  } catch (error) {
    throw handleError(error);
  }
};

export const uploadImage = async ({ url, file, id }) => {
  try {
    const formData = new FormData();
    formData.append("file", file);

    const response = await axios.post(`${url}`, formData, {
      headers: {
        authorization: "senpai",
        "Content-Type": "multipart/form-data",
        userid: id,
      },
    });
    if (response.status === 200) {
      console.log("Uploading Image");
      return response;
    }
  } catch (error) {
    throw handleError(error);
  }
};

// Delete Image

export const deleteImage = async ({ url, imgUrl }) => {
  try {
    const response = await axios.post(
      url,
      { url: imgUrl },
      {
        headers: {
          authorization: "senpai",
          "Content-Type": "application/json",
        },
      }
    );
    if (response.status === 200) {
      console.log("Deleting Image");
      return response;
    }
  } catch (error) {
    console.log(error);
  }
};
