require("dotenv").config();

const connectDB = require("./src/clients/mongo_client.js");
const app = require("./src/app.js");

connectDB()
  .then(() => {
    app.listen(process.env.PORT || 3001, "0.0.0.0", () => {
      console.log(`Server is running at port : ${process.env.PORT}`);
    });
  })
  .catch((error) => {
    console.log("MONGODB connection failed! ", error);
  });
