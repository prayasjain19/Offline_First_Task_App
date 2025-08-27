import { pgTable, uuid, text, timestamp } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),
    email: text("email").notNull().unique(),
    password: text("password").notNull(),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
});


//This is when we want to Access User
export type User = typeof users.$inferSelect;
//This is when we want to create New User
export type NewUser = typeof users.$inferInsert;

export const tasks = pgTable("tasks", {
    id: uuid().primaryKey().defaultRandom(),
    title: text("title").notNull(),
    description: text("description").notNull(),
    hexColor: text("hex_color").notNull(),
    uid: uuid("uid").notNull().references(() => users.id, { onDelete: "cascade" }),
    dueAt: timestamp("due_at").$defaultFn(() => new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
});

//This is when we want to Access Tasks
export type Task = typeof tasks.$inferSelect;
//This is when we want to create New Task
export type NewTask = typeof tasks.$inferInsert;