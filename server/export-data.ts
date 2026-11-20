import { db } from "./db";
import * as schema from "@shared/schema";

async function exportAll() {
  const result: Record<string, any> = {};

  for (const [key, value] of Object.entries(schema)) {
    // Only export real tables
    if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
      try {
        // @ts-ignore
        const rows = await db.select().from(value);
        result[key] = rows;
      } catch (e) {
        // Skip non-table exports
      }
    }
  }

  console.log(JSON.stringify(result, null, 2));
  process.exit(0);
}

exportAll();
