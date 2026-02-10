const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("GitOps Platform App is running");
});

app.listen(3000, () => {
  console.log("App running on port 3000");
});

#Run CI Test
