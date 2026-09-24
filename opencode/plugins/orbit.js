import { existsSync } from "fs";
import { join } from "path";
import { homedir } from "os";

const REMINDER = "[orbit] Grep means run glab orbit grep 'words'. FTS, not regex.";

export default {
  id: "orbit",
  async setup(ctx) {
    let reminded = false;
    const root = process.env.ORBIT_DATA_DIR || join(homedir(), ".gitlab", "orbit");

    await ctx.tool.hook("execute.after", (event) => {
      if (reminded) return;
      if (event.tool !== "shell") return;
      if (!existsSync(join(root, "graph.duckdb"))) return;
      if (event.status !== "completed") return;
      if (typeof event.result.content === "string") {
        event.result.content += "\n\n" + REMINDER;
      } else {
        event.result.content = [...(event.result.content || []), { type: "text", text: REMINDER }];
      }
      reminded = true;
    });
  },
};
