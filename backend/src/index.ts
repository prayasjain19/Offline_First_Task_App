import express from "express";
import authRouter from "./routes/auth.js";
import taskRouter from "./routes/tasks.js";

const app = express();


app.use(express.json());
app.use("/auth", authRouter);
app.use("/tasks", taskRouter);

app.get("/", (req, res) => {
    res.send("Welcome to App!!");
})

app.listen(8000, '0.0.0.0', () => {
    console.log("Server is Running on Post 8000!");
})