import { Router } from "express";
import { auth, type AuthRequest } from "../middleware/auth.js";
import { tasks, type NewTask } from "../db/schema.js";
import { db } from "../db/index.js";
import { eq } from "drizzle-orm";

const taskRouter = Router();

//Create New Task
taskRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        //create a new task
        //add id of user in req body
        req.body = {...req.body, dueAt: new Date(req.body.dueAt), uid: req.user};
        const newTask: NewTask = req.body;

        //insert in db
        const [task] = await db.insert(tasks).values(newTask).returning();

        res.status(201).json(task);
    } catch (error) {
        res.status(500).json({error: error});
    }
});

//get all task of a particular user
taskRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const allTasks = await db.select().from(tasks).where(eq(tasks.uid, req.user!));

        res.json(allTasks);
    } catch (error) {
        res.status(500).json({error: error});
    }
});

//Delete a Task
taskRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const {taskId}: {taskId: string} = req.body;

        await db.delete(tasks).where(eq(tasks.id, taskId));

        res.json(true);
    } catch (error) {
        res.status(500).json({error: error});
    }
});

export default taskRouter;