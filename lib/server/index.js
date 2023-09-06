const express = require('express')
const mongoose = require('mongoose');
const DB = 'mongodb+srv://edersonspt:RS7GbYCNi1Iwju8K@mstock0.lapwnrp.mongodb.net/?retryWrites=true&w=majority';
const app = express()
const cors = require('cors');

//routes
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);

mongoose.connect(DB).then(() => {
    console.log("Connected to DataBase")
}).catch(
    (e) => {
        console.log(e);
    }
);

app.listen(3000, "0.0.0.0", () => {
    console.log(`connected at port 3000`);
});