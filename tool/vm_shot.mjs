// 校验运行中应用：获取 widget 树摘要 + 截图
// 用法: node tool/vm_shot.mjs <wsUrl> <out.png>
import { writeFileSync } from "node:fs";

const [wsUrl, outFile] = process.argv.slice(2);
const ws = new WebSocket(wsUrl);
let id = 0;
const pending = new Map();

function call(method, params = {}) {
  return new Promise((resolve, reject) => {
    const msgId = ++id;
    pending.set(msgId, { resolve, reject });
    ws.send(JSON.stringify({ jsonrpc: "2.0", id: msgId, method, params }));
  });
}

ws.onmessage = (ev) => {
  const msg = JSON.parse(ev.data);
  if (msg.id && pending.has(msg.id)) {
    const { resolve, reject } = pending.get(msg.id);
    pending.delete(msg.id);
    msg.error ? reject(new Error(JSON.stringify(msg.error).slice(0, 300))) : resolve(msg.result);
  }
};

ws.onopen = async () => {
  try {
    const vm = await call("getVM");
    const isolateId = vm.isolates[0].id;

    // 1) widget 树摘要
    const tree = await call("ext.flutter.inspector.getRootWidgetSummaryTree", {
      isolateId, groupName: "smoke",
    });
    const treeStr = typeof tree === "string" ? tree : JSON.stringify(tree);
    console.log("WIDGET TREE SUMMARY:", treeStr.slice(0, 1500));

    // 2) 根 widget id 供截图
    const root = await call("ext.flutter.inspector.getRootWidget", { isolateId, groupName: "smoke" });
    const rootId = (root && (root.valueId ?? root.id)) ?? root;
    console.log("ROOT ID:", JSON.stringify(rootId));

    const shot = await call("ext.flutter.inspector.screenshot", {
      isolateId, id: rootId, width: 430, height: 932, maxPixelRatio: 1,
    });
    const b64 = shot.screenshot ?? shot.result;
    if (!b64) {
      console.error("unexpected result:", JSON.stringify(shot).slice(0, 200));
      process.exit(4);
    }
    writeFileSync(outFile, Buffer.from(b64, "base64"));
    console.log("saved:", outFile);
    ws.close();
    process.exit(0);
  } catch (e) {
    console.error("error:", e.message);
    process.exit(1);
  }
};

setTimeout(() => { console.error("timeout"); process.exit(2); }, 30000);
