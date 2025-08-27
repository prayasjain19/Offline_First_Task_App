
import type { UUID } from "crypto";
import type {Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { db } from "../db/index.js";
import { users } from "../db/schema.js";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
    user?: UUID;
    token?: string;
}

export const auth = async (req: AuthRequest, res: Response, next: NextFunction) => {
        try {
            //get the header
            const token = req.header("x-auth-token");

            if (!token) {
                res.status(401).json({
                    error: "No Auth Token, access denied!"
                })
                return;
            };
            //verify the token is valid or not
            const verified = jwt.verify(token, "PRAYAS");

            if (!verified) {
                res.status(401).json({
                    error: "Token verification Failed"
                })
                return
            };
            //get the user if token is valid

            const verifiedToken = verified as { id: UUID };

            const [user] = await db
                .select()
                .from(users)
                .where(eq(users.id, verifiedToken.id));
            //if no user, return false
            if (!user) {
                res.status(401).json({
                    error: "User not found"
                })
                return;
            };
            req.user = verifiedToken.id;
            req.token = token;
            next();
        } catch (error) {
            res.status(500).json({error: error});
        }
}