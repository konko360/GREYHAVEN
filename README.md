# GREYHAVEN · 灰港镇

> 基于 Three.js 的可漫游 3D RPG 城镇原型，包含真实开源模型、NPC 对话、怪兽战斗、昼夜循环与本地资产缓存。

![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6.svg)
![Three.js](https://img.shields.io/badge/Renderer-Three.js-000000.svg)
![Status](https://img.shields.io/badge/Status-Playable-brightgreen.svg)

## 项目简介

**GREYHAVEN · 灰港镇** 是一个无需安装游戏引擎、可在桌面浏览器中运行的 3D RPG 城镇探索与战斗原型。项目采用单 HTML 游戏主体与单 BAT 启动器，启动后自动建立本地 HTTP 服务，并优先读取已经缓存到本机的模型资源。

首次运行需要联网获取开源 3D 资产。下载失败不会阻止游戏启动：本地文件缺失时，HTML 会尝试从固定在线源加载；成功缓存后可优先使用本地资产。

![image1](images1.png)

## 核心功能

- 可自由漫游的中世纪幻想城镇
- 住宅、酒馆、铁匠铺、市场、教堂、城堡、塔楼、道路、树木与岩石等真实 GLTF 资产
- 带骨骼与动画的 NPC，以及距离交互和分支对话
- NPC 名称牌支持场景深度遮挡
- 骷髅怪兽追踪、攻击、死亡与刷新
- 主角使用火球进行远程攻击
- 火球命中后的击退、闪烁和粒子反馈
- 玩家受伤时的红色冲击遮罩与相机震荡
- 玩家死亡后返回广场复活
- 保留原有 HUD，并增加玩家生命条
- 自动昼夜循环；夜间保留适当环境光
- 城镇边界限制，防止角色离开可玩区域
- 本地资产优先、在线资源回退、后台缓存
- 无 npm、无构建步骤、无独立安装程序

## 快速开始

![image2](images2.png)

### 系统要求

- Windows 10 或 Windows 11
- Microsoft Edge、Google Chrome 或其他支持 WebGL 2 的现代浏览器
- 首次运行时需要互联网连接
- 系统可使用 `PowerShell` 与 `curl.exe`（现代 Windows 默认提供）

### 启动步骤

1. 下载并完整解压项目。
2. 双击：

```text
Start_Town.bat
```

3. 保持命令窗口开启。
4. 浏览器会自动打开游戏页面。
5. 首次运行期间，启动器会在后台缓存缺失资产。

> 不建议直接双击 `RPG_Town_Explorer.html`。浏览器的 `file://` 安全限制可能阻止 GLTF、BIN、PNG 和 GLB 等本地资源加载。

## 操作方式

| 操作 | 按键 |
|---|---|
| 移动 | `W` `A` `S` `D` |
| 奔跑 | `Shift` |
| 跳跃 | `Space` |
| 观察 | 鼠标移动 |
| 发射火球 | 鼠标左键或 `F` |
| 与 NPC 对话 | `E` |
| 关闭对话／释放鼠标 | `Esc` |
| 隐藏或显示 HUD | `H` |
| 返回广场 | `R` |

![image3](images3.png)

## 战斗规则

- 怪兽进入警戒范围后会追踪玩家。
- 怪兽靠近后会发动近战攻击。
- 火球命中怪兽会造成伤害、击退并触发短暂闪烁。
- 玩家受伤后会获得短暂无敌时间，避免连续瞬间扣血。
- 生命值降至零后，玩家会回到城镇广场并恢复生命。
- 被击败的怪兽会在一段时间后于原出生区域刷新。

## 目录结构

```text
GREYHAVEN/
├─ RPG_Town_Explorer.html     # Three.js 游戏主体与全部游戏逻辑
├─ Start_Town.bat             # 唯一启动入口、本地服务器与后台资产缓存
├─ README.md
├─ LICENSE                    # 项目源代码的 MIT License
├─ LICENSES.md                # 第三方组件与资产许可说明
└─ assets/                    # 首次运行后逐步生成
   ├─ gltf/                   # 城镇环境模型、BIN 与材质图集
   ├─ npc/                    # NPC GLB 模型
   └─ monsters/               # 怪兽 GLB 模型
```

## 资产加载机制

游戏按以下顺序读取模型：

```text
本地 assets 目录
→ jsDelivr 固定提交
→ GitHub Raw 固定提交
→ 跳过单个不可用模型，继续运行场景
```

浏览器在线加载模型只会将数据放入内存或浏览器缓存，不会自动写入项目目录。`Start_Town.bat` 会在后台把相同资源明确保存到 `assets` 目录，从而为后续离线运行建立本地缓存。

## 技术栈

- Three.js
- WebGL 2
- GLTF / GLB
- JavaScript ES Modules
- Windows Batch
- Windows PowerShell 本地静态服务器

项目没有 Node.js、npm、Webpack、Vite 或其他构建依赖。

## 开发说明

### 修改游戏

主要游戏代码集中在：

```text
RPG_Town_Explorer.html
```

资产清单同时存在于 HTML 与 `Start_Town.bat`。新增或替换模型时，应确保两处路径保持一致，否则模型可能只能在线加载，无法正确缓存到本地。

### 清除本地资产缓存

关闭游戏后删除：

```text
assets/
```

再次启动时，系统会重新获取缺失资产。

### 更换端口

启动器默认从 `8765` 开始寻找可用本地端口，若端口被占用，会继续尝试后续端口。

## 已知限制

- 当前启动器主要面向 Windows。
- 首次资源缓存速度取决于 GitHub 或 CDN 的网络连接质量。
- 部分模型下载失败时，游戏仍可通过在线回退运行，但离线状态下可能缺少相应资产。
- 这是可玩技术原型，不包含存档、完整任务系统、正式关卡流程或多人联网功能。

## 许可证

项目原创源代码使用 **MIT License**，详见 [LICENSE](LICENSE)。

第三方库和美术资产不因本项目的 MIT License 而改变其原始许可。当前使用的 KayKit 资产为 **CC0 1.0 Universal**，Three.js 使用 MIT License。完整说明见 [LICENSES.md](LICENSES.md)。

## 第三方资源

- [Three.js](https://github.com/mrdoob/three.js)
- [KayKit Medieval Hexagon Pack](https://github.com/KayKit-Game-Assets/KayKit-Medieval-Hexagon-Pack-1.0)
- [KayKit Character Pack: Adventurers](https://github.com/KayKit-Game-Assets/KayKit-Character-Pack-Adventures-1.0)
- [KayKit Character Pack: Skeletons](https://github.com/KayKit-Game-Assets/KayKit-Character-Pack-Skeletons-1.0)

## 贡献

欢迎通过 Issue 报告问题，或通过 Pull Request 提交改进。提交前请尽量说明：

- Windows 与浏览器版本
- 控制台错误信息
- 是否已生成 `assets` 目录
- 问题是否只在离线状态出现

---

**GREYHAVEN · 灰港镇** — 一个以真实开源资产、轻量运行方式和可持续迭代为目标的浏览器 3D RPG 城镇实验项目。
