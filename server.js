import express from "express";
import { spawn } from "child_process";
import fs from "fs";
import path from "path";

const app = express();
app.use(express.json());

app.post("/chat", (req, res) => {
  const { prompt, userId } = req.body;
  if (!prompt || !userId) {
    return res.status(400).json({ error: "missing prompt/userId" });
  }

  // TODO: تحقق من اشتراك المستخدم هون قبل ما تكمل

  const workDir = path.join("/tmp/codex-sessions", userId);
  fs.mkdirSync(workDir, { recursive: true });

  const codex = spawn("codex", [
    "exec", prompt,
    "--cd", workDir,
    "--skip-git-repo-check",
    "--dangerously-bypass-approvals-and-sandbox"
  ]);

  let output = "";
  codex.stdout.on("data", (d) => (output += d.toString()));
  codex.stderr.on("data", (d) => (output += d.toString()));
  codex.on("close", () => res.json({ output }));
});

app.listen(process.env.PORT || 3000, () => console.log("server up"));
