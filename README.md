# localops-windows

**Preview / Alpha · 源码预览**

localops-windows是面向 Windows 的本地服务与批处理任务快速启动、运行监测工具。它把常用项目命令、长期服务和一次性批处理任务集中到本地网页中，并用 Python 3 标准库提供只绑定回环地址的后端；前端是无构建、无 CDN 的原生 HTML/CSS/JavaScript。

localops-windows只服务当前电脑和当前用户，不是远程运维、多人协作或公网管理面板。它能够以当前用户权限执行保存的命令；不要将监听地址、反向代理、SSH 隧道或端口映射暴露到不受信任的网络。

## 功能

- 每 2 秒查看当前用户的本地监听服务、CPU、内存和运行时长。
- 保存常用服务或批处理任务，集中启动、停止、重启、查日志和诊断。
- 在当前页面会话中发现新出现的、尚未管理的监听端口，可直接加入启动台或忽略隐藏。
- 运行前检查工作目录、脚本和运行时；明确失效时直接给出修复入口。
- 从项目文件夹识别常用启动命令，但不安装依赖、不执行项目代码。
- 通过运行 token、进程树和当前用户联合识别受控进程，不会因端口相同就杀死外部进程。
- Ops 指挥台单一主题：深空蓝黑/雾灰双色，左侧导航轨、KPI 概览卡、实时动态侧栏，浅色、深色和跟随系统。
- 全局命令面板可直接添加服务或批处理任务；启动台卡片支持鼠标拖拽和键盘排序。

## 系统要求

- Windows 10/11 或更高版本。
- Python 3.12。运行时仅使用 Python 标准库。
- Windows 自带的 `netstat`、PowerShell 与进程 API，无需额外安装。
- Chrome、Edge 或其他支持 ES Modules 的现代浏览器。

`VERSION` 是项目版本的唯一权威来源。

## 安装

1. **下载并解压**：将发行 zip 解压到一个你有读写权限的目录。
2. **确认 Python 3.12**：在 PowerShell 中运行：

   ```powershell
   python --version
   ```

   未安装或版本过低时，到 <https://www.python.org/downloads/> 下载安装包，
   安装时勾选 “Add python.exe to PATH”。

## 运行

| 方式 | 操作 | 适用场景 |
| --- | --- | --- |
| 后台运行 | `powershell -WindowStyle Hidden -File start.ps1` | 日常使用，不占用控制台窗口 |
| 前台调试 | 双击 `start.bat` | 想实时看启动输出 |
| 命令行 | `python server.py` | 调试、脚本化 |

命令行可选参数：

```powershell
python server.py --no-browser        # 只启动服务，不自动打开浏览器
python server.py --preferred-port 9603  # 在 9600-9609 内指定优先端口
```

`start.bat` / `start.ps1` 会自动查找 PATH 中的 Python、常见安装目录，以及本机 Codex 自带的 Python。如果仍提示缺少 Python，请安装 Python 3.12+ 并勾选 “Add python.exe to PATH”。

启动后程序只绑定 `127.0.0.1`，从 9600 起尝试端口，被占用则递增（最多 10 个），并自动打开浏览器。命令行参数、环境变量（`CONSOLE_DATA_DIR` / `CONSOLE_LOG_DIR`）见下文“数据、隐私与备份”。

**实际地址在哪里看**：顶栏「重启 :9600」按钮上直接显示当前端口；或看终端输出 / `%LOCALAPPDATA%\localops-windows\logs\console.log`。浏览器手动访问 `http://127.0.0.1:端口号/` 即可。

**停止与重启**：顶栏「重启 / 停止」控制的是localops-windows自身（网页服务）。停止localops-windows**不会**停止启动台里已经运行的应用——它们是独立进程树，会继续运行；下次打开localops-windows时会自动重新识别。

## 使用

打开页面后，左侧是导航轨，右侧是信息栏；所有数据每 2 秒自动刷新。

### 启动台（管理你的服务与任务）

- **添加服务/任务**：点「+ 添加服务」卡片或页头快捷按钮。选择工作区文件夹后会自动识别项目类型（Node/pnpm、Hexo/Hugo、Django/FastAPI、Go、Rust、静态站点等）并给出候选命令；也可以「选择脚本」或完全手动填写。`service` 是长期服务（带端口语义），`task` 是有明确结束时间的批处理（强制无端口）。
- 卡片：大按钮启动/停止（任务是运行/中止）；右侧一排小按钮（复制链接/日志/诊断/重启/编辑/删除）常显。运行中显示端口与时长；配置失效会直接标出原因并禁用启动。
- 筛选：每个分区右上角可按 全部/运行中/已停止/异常（任务为 全部/运行中/成功/失败/已取消）过滤。
- 排序：鼠标拖拽，或聚焦卡片后按空格进入键盘排序。
- 批量停止：右侧「快捷操作」里可一键停止全部运行中的应用（有确认框，逐个安全停止，绝不按端口杀进程）。

### 服务监控（看这台电脑在跑什么）

- 概览卡：在线服务/后台应用/总 CPU/总内存（带最近一分钟负载曲线）/端口警告/最后更新。
- 服务表格：每个服务的 PID、端口、目录、负载、时长、状态，以及启动者徽标。点端口直接打开服务；行尾按钮可加入启动台、置顶、隐藏、展开完整命令或安全结束进程。
- 发现新端口：页面打开期间新出现的监听端口会单独提醒，可一键「加入启动台」「忽略并隐藏」或「暂时关闭」。
- 关注的进程：输入关键字回车，匹配进程实时列出。

### 日志中心（Ctrl+J）

导航轨「日志中心」或快捷键 Ctrl+J：所有应用按运行中优先排列，点开任意一行看实时日志；底部固定localops-windows自身日志入口。

### 设置中心

导航轨齿轮：任务完成通知开关、外观三态（自动/浅色/深色）、版本/端口/工作目录/数据目录信息。

### 命令面板（Ctrl+K）

全局搜索并执行：添加服务/任务、启动/停止/重启任意应用、打开页面、查看日志、切换视图、开关任务通知、查看localops-windows日志等。

## 数据、隐私与备份

运行数据与程序目录分离，默认放在：

| 路径 | 内容 | 备份建议 |
| --- | --- | --- |
| `%APPDATA%\localops-windows\config.json` | 应用命令、本地路径、端口、标记和运行识别信息 | 必须 |
| `%APPDATA%\localops-windows\config.json.bak` | 上一份已知良好的配置 | 必须 |
| `%APPDATA%\localops-windows\icons\` | 用户上传的图标和站点图标 | 按需 |
| `%LOCALAPPDATA%\localops-windows\logs\` | 应用与localops-windows运行日志 | 通常不需 |

Windows 下如果默认数据目录不可写，会自动改用项目内 `data` 目录，避免因权限问题启动失败。这些文件仍可能含个人路径、完整命令和日志内容；不应进入 Git，也不应随发行包或故障报告对外传播。

需要自定义路径时：

```powershell
$env:CONSOLE_DATA_DIR = "D:\console-data"
$env:CONSOLE_LOG_DIR = "D:\console-logs"
python server.py
```

自定义值必须是非空的绝对路径，并指向localops-windows专用的子目录。

## 安全边界

- 只添加你已检查且信任的命令和工作目录。
- 不要将服务绑定到 `0.0.0.0`，不要通过反向代理、SSH 隧道或端口映射对外暴露。
- 不要把 `%APPDATA%\localops-windows\config.json`、日志或故障截图未经脱敏就上传。
- 本地回环绑定只是第一层边界，不能替代写接口的 Host/Origin/控制令牌防护。

## 故障排查

### 双击后没有界面

- 确认 `python --version` 可用且符合要求。
- 查看 `%LOCALAPPDATA%\localops-windows\logs\console.log`。
- 用 `python server.py` 从终端启动，直接查看错误。

### 9600 打不开

程序可能已选择 9601–9609。查看终端输出或 `%LOCALAPPDATA%\localops-windows\logs\console.log` 中的实际地址。服务可访问时，`GET /api/health` 会返回程序版本、配置 schema 和降级原因。

## 开发

运行时无第三方 Python 依赖。重新生成品牌图标时需要开发依赖：

```powershell
python -m venv .venv
.venv\Scripts\activate
python -m pip install -r requirements-dev.txt
```

主要目录：

```text
server.py                 Python 标准库后端
static/                   原生前端、主题、品牌、图标和字体
tests/                    后端、前端契约、发布与交付检查
tools/gen_brand_assets.py 从品牌主图生成 favicon 与网页图标
tools/gen_icons.py         由 vendored SVG 生成 icons.js
tools/check_project.py     统一的只读项目检查
data/                      本地运行数据（不进 Git/发行包）
```

### 检查

```powershell
python tools/check_project.py
```

它会检查 Python/JavaScript/PowerShell/JSON 语法、版本一致性、主题和资源引用、生成的图标是否同步，并显式发现和运行测试。测试数量为 0 时会失败。

只运行后端测试：

```powershell
python -m unittest discover -s tests -p "test_*.py" -v
```

正式发布前还应运行：

```powershell
python tools/build_release.py --check-only
```

### 重新生成资源

```powershell
python tools/gen_icons.py
python tools/gen_brand_assets.py
python tools/check_project.py
```

`static/icons.js` 是生成文件，不应手工修改。

## 发布

请按 `RELEASE_CHECKLIST.md` 逐项验收。一个可对外交付的版本至少需要：

- 干净、可追溯的 Git commit 和带签名版本 Tag。
- 通过 `python tools/check_project.py` 和人工 UI/安全/升级/回滚验收。
- 不含任何项目内旧 `data/`、用户数据、日志、绝对路径、token 或缓存的发行包。

## 许可与第三方素材

项目自有代码和文档采用 MIT License。Lucide、Geist Mono 以及项目生成图像等素材可能适用各自的许可或发布限制，详见 `THIRD_PARTY_NOTICES.md` 与 `ASSET_PROVENANCE.md`。
