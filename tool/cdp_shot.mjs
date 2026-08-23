// CDP 冒烟截图：真实等待 15 秒后再截图（避开 virtual-time 与 SharedWorker 不兼容问题）
// 用法: node tool/cdp_shot.mjs <url> <out.png> [waitSeconds]
const url = process.argv[2] ?? "http://localhost:8080";
const out = process.argv[3] ?? "tool/cdp_shot.png";
const waitSec = Number(process.argv[4] ?? 15);

const targets = await (await fetch("http://localhost:9222/json")).json();
const page = targets.find((t) => t.type === "page");
if (!page) {
  console.error("no page target");
  process.exit(1);
}

const ws = new WebSocket(page.webSocketDebuggerUrl);
let id = 0;
const pending = new Map();
const consoleLogs = [];

function send(method, params = {}) {
  return new Promise((resolve, reject) => {
    const msgId = ++id;
    pending.set(msgId, { resolve, reject });
    ws.send(JSON.stringify({ id: msgId, method, params }));
  });
}

ws.onmessage = (ev) => {
  const msg = JSON.parse(ev.data);
  if (msg.id && pending.has(msg.id)) {
    const { resolve, reject } = pending.get(msg.id);
    pending.delete(msg.id);
    msg.error ? reject(new Error(msg.error.message)) : resolve(msg.result);
    return;
  }
  if (msg.method === "Runtime.consoleAPICalled") {
    const text = (msg.params.args ?? [])
      .map((a) => a.value ?? a.description ?? "")
      .join(" ");
    consoleLogs.push(`[console.${msg.params.type}] ${text}`);
  } else if (msg.method === "Runtime.exceptionThrown") {
    consoleLogs.push(`[exception] ${JSON.stringify(msg.params.exceptionDetails).slice(0, 500)}`);
  }
};

ws.onopen = async () => {
  try {
    await send("Page.enable");
    await send("Runtime.enable");
    await send("Page.navigate", { url });
    await new Promise((r) => setTimeout(r, waitSec * 1000));
    const shot = await send("Page.captureScreenshot", { format: "png" });
    const { writeFileSync } = await import("node:fs");
    writeFileSync(out, Buffer.from(shot.data, "base64"));
    console.log("screenshot saved:", out);
    console.log("--- console ---");
    for (const line of consoleLogs) console.log(line);
    console.log("--- end console ---");
    ws.close();
    process.exit(0);
  } catch (e) {
    console.error("CDP error:", e.message);
    process.exit(1);
  }
};

setTimeout(() => {
  console.error("timeout waiting for CDP");
  process.exit(2);
}, 60000);
