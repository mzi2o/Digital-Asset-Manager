import bcrypt from "bcryptjs";
import { eq } from "drizzle-orm";
import { users } from "@shared/schema";
import { db, pool } from "./db";
import { createInterface } from "node:readline/promises";
import { stdin, stdout } from "node:process";

function readHidden(prompt: string): Promise<string> {
  return new Promise((resolve, reject) => {
    if (!stdin.isTTY || typeof stdin.setRawMode !== "function") {
      reject(new Error("Run this command in an interactive terminal."));
      return;
    }

    let value = "";
    stdout.write(prompt);
    stdin.setRawMode(true);
    stdin.resume();

    const finish = (result?: string, error?: Error) => {
      stdin.off("data", onData);
      stdin.setRawMode(false);
      stdout.write("\n");
      error ? reject(error) : resolve(result ?? "");
    };

    const onData = (input: Buffer) => {
      const key = input.toString("utf8");
      if (key === "\u0003") return finish(undefined, new Error("Password reset cancelled."));
      if (key === "\r" || key === "\n") return finish(value);
      if (key === "\u007f" || key === "\b") {
        if (value.length) {
          value = value.slice(0, -1);
          stdout.write("\b \b");
        }
        return;
      }
      if (/^[\x20-\x7e]+$/.test(key)) {
        value += key;
        stdout.write("*".repeat(key.length));
      }
    };

    stdin.on("data", onData);
  });
}

async function main() {
  if (!stdin.isTTY) {
    throw new Error("Run this command in an interactive terminal.");
  }

  const prompt = createInterface({ input: stdin, output: stdout });
  const username = (await prompt.question("Username: ")).trim().toLowerCase();
  prompt.close();

  const newPassword = await readHidden("New password (at least 12 characters): ");
  if (!username) throw new Error("Username is required.");
  if (newPassword.length < 12) throw new Error("Choose a password with at least 12 characters.");

  const [user] = await db.select().from(users).where(eq(users.username, username));
  if (!user) throw new Error("User not found.");

  const passwordHash = await bcrypt.hash(newPassword, 12);
  await db.update(users).set({ passwordHash, isActive: true }).where(eq(users.id, user.id));
  console.log(`Password reset successfully for ${user.username}.`);
}

main()
  .catch((error) => {
    console.error(`Password reset failed: ${error instanceof Error ? error.message : "Unknown error"}`);
    process.exitCode = 1;
  })
  .finally(async () => {
    await pool.end();
  });
