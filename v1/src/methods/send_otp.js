const FormData = require("form-data");
const axios = require("axios");

const sendOtpEmail = async (email, otp) => {
  const apiUrl = "https://sendmail.minekrypton.com";

  const formData = new FormData();
  formData.append("recipient", email);
  formData.append("code", otp);

  const response = await axios.post(apiUrl, formData, {
    headers: { ...formData.getHeaders() },
  });
  return response;
};

function generateOTP() {
  const min = 100000;
  const max = 999999;

  return Math.floor(Math.random() * (max - min + 1)) + min;
}

module.exports = { sendOtpEmail, generateOTP };
