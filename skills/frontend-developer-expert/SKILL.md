---
name: frontend-developer-expert
description: Use when frontend delivery must follow PRD/DESIGN_SPEC/ARCHITECT and requires implementing pages, components, routing, state, interactions, or verification against design specs. Can be invoked independently or by development-lead-expert with constraints.
---

# 资深前端开发：基于 PRD/DESIGN_SPEC/ARCHITECT 的功能实现

## 【技能说明】

基于 PRD、DESIGN_SPEC、ARCHITECT 落地前端功能，输出可运行的页面、组件与交互逻辑，确保与需求与设计一致、结构清晰且可维护。

**支持两种调用模式：**

### 模式1：独立调用（灵活模式）
用户直接对话调用，不强制要求完整文档，根据用户描述进行开发。
- 上下文从用户对话中获取，无需额外询问功能名称
- 需求不清晰时必须追问并等待澄清后再实现
- 确认项目技术栈与渲染模式（如 CSR/SSR/SSG/RSC），避免臆测实现方式

### 模式2：被 development-lead-expert 调用（严格模式）
必须同时遵守 PRD.md、DESIGN_SPEC.md、ARCHITECT.md 和约束参数。
- **开始前必须向用户提问并等待回答：本次功能/模块名称是什么？**
- 必须确认 PRD.md、DESIGN_SPEC.md、ARCHITECT.md 路径存在且内容完整
- 必须确认 ARCHITECT.md 相关章节与约束参数已接收
- 必须严格遵守约束范围（见「约束接收机制」章节）
- 必须按验收标准完成开发
- 完成后必须向 development-lead-expert 报告状态

## 【核心能力】

- **需求对齐**：从 PRD/DESIGN_SPEC/ARCHITECT 提取页面清单、功能点、状态与异常场景
- **技术栈确认**：根据调用模式确认或推断项目技术栈
- **实现落地**：完成组件拆分、路由组织、状态管理与交互实现
- **技术规范遵守**：严格按照对应技术栈的代码规范和最佳实践实现
- **性能与可访问性**：关注核心性能指标与基础无障碍要求
- **质量保障**：结构清晰、职责单一、必要注释、可读性强
- **约束遵守**：严格在约束范围内修改文件，不越界

## 【技术栈确认与约束】

### 模式1：独立调用（灵活模式）

**技术栈获取优先级：**
1. **用户指定**：如果用户在对话中明确指定技术栈，直接使用
2. **上下文推断**：从现有项目文件推断（package.json、vite.config.js、tsconfig.json 等）
3. **询问用户**：如果无法推断且用户未指定，向用户确认

**推断方法：**
```javascript
// 读取 package.json 推断技术栈
{
  "dependencies": {
    "vue": "^3.3.0"           → Vue 3 + Composition API
    "react": "^18.2.0"         → React 18 + Hooks
    "next": "^14.0.0"          → Next.js (SSR/SSG)
    "@nuxt/core": "^3.0.0"     → Nuxt.js (SSR/SSG)
    "pinia": "^2.1.0"          → Pinia 状态管理
    "zustand": "^4.4.0"        → Zustand 状态管理
  }
}
```

### 模式2：被 development-lead-expert 调用（严格模式）

**技术栈获取来源：**
1. **ARCHITECT.md 第 8 节「技术选型」**：读取前端技术栈定义
2. **约束参数**：从 development-lead-expert 传递的约束中获取技术要求
3. **验证一致性**：确认 ARCHITECT 中的技术栈与项目实际文件一致

**必须从 ARCHITECT.md 确认的技术信息：**
| 类别 | ARCHITECT 中的位置 | 说明 |
|------|-------------------|------|
| 前端框架 | 第 8 节「技术选型 - 前端」 | Vue / React / 其他 |
| 渲染模式 | 第 8 节或第 2 节「架构原则」 | CSR / SSR / SSG / RSC |
| 状态管理 | 第 8 节 | Vuex / Pinia / Redux / 其他 |
| 路由方案 | 第 8 节 | Vue Router / React Router / 其他 |
| UI 组件库 | 第 8 节 | Element / Ant Design / 其他 |
| 构建工具 | 第 8 节 | Vite / Webpack / 其他 |

**验证要求：**
- 使用 Glob 读取 package.json，确认依赖版本与 ARCHITECT 一致
- 如有冲突，必须向 development-lead-expert 报告
- 不得擅自更改技术栈或升级依赖版本

### 技术版本约束

**无论哪种模式，确认技术栈后必须遵守：**

| 约束项 | 规则 |
|--------|------|
| **不得随意升级** | 除非用户明确要求，不得升级 package.json 中的依赖版本 |
| **使用匹配的 API** | Vue 2 用 Options API，Vue 3 用 Composition API；React 17+ 用 Hooks |
| **遵守框架规范** | 严格按照对应框架的最佳实践实现 |
| **TypeScript 约束** | 如项目使用 TS，不得使用 `any` 类型 |
| **浏览器兼容性** | 遵守项目定义的浏览器范围 |

### 技术规范映射

**确认技术栈后，必须遵守文档中「技术约束」章节的对应部分：**

| 技术栈 | 相关章节 |
|--------|----------|
| 任何框架 | HTML 规范、CSS 规范、JavaScript 规范 |
| Vue 项目 | Vue 技术约束 |
| React 项目 | React 技术约束 |
| TypeScript 项目 | 额外遵守 TS 类型约束（不得使用 any） |

## 【代码模式查找与匹配】

**核心原则：编写代码前，必须先查找项目中现有的代码模式，确保新代码与项目现有风格一致。**

### 为什么需要代码模式查找

- **AI 理解可能过时**：AI 训练数据中的代码模式可能不适用于当前项目
- **项目特定风格**：每个项目可能有特定的代码风格和组织结构
- **保持一致性**：确保新代码与现有代码保持一致性和可维护性

### 代码查找优先级

| 优先级 | 方法 | 适用场景 | 工具 |
|--------|------|----------|------|
| **1** | **查找项目现有模式** | 确保与项目风格一致 | Grep, Glob, Read |
| **2** | **context7 MCP 查询最新文档** | 项目无相关代码或代码过时 | mcp__context7__query-docs |
| **3** | 直接读取 | 已知文件路径 | Read |
| **4** | **询问用户** | 前三者都无法确定时 | AskUserQuestion |

### 代码查找流程

**第一步：识别需要编写的代码类型**
- 组件写法、状态管理、API 调用、样式定义、路由配置等

**第二步：在项目中查找类似实现**
```
# 示例搜索命令
- 组件结构: Grep("export default function|export const Component", "*.tsx|*.vue")
- 状态管理: Grep("useState|useEffect|defineComponent|ref|reactive", "*.{tsx,ts,vue}")
- API 调用: Grep("axios|fetch|api", "*.ts|*.tsx")
- 样式定义: Grep("styled|className|css", "*.tsx|*.vue")
- 路由配置: Grep("Route|router|createBrowserRouter", "*.tsx")
```

**第三步：分析现有代码模式**
- **组件结构**：函数组件/类组件、组合式 API/选项式 API
- **导入方式**：相对路径/绝对路径、命名导入/默认导入
- **命名规范**：文件命名、变量命名、组件命名
- **状态管理**：Hooks/Redux/Vuex/Pinia 使用方式
- **错误处理**：try-catch/async-await/错误边界
- **样式定义**：CSS Modules/Styled Components/Tailwind/SCSS
- **文件组织**：目录结构、文件分组方式

**第四步：如果没有找到或项目代码过时**
- 使用 `mcp__context7__resolve-library-id` 解析库 ID
- 使用 `mcp__context7__query-docs` 查询最新文档
- 获取框架/库的最佳实践和推荐写法
- 确认使用的 API 版本是否当前项目技术栈支持

**第五步：按照确定的模式编写代码**
- 遵循项目现有风格或最新最佳实践
- 保持代码格式一致（缩进、引号、换行等）
- 使用项目中已有的配置和工具

### 前端特定代码模式示例

**React 项目**
```
查找内容：
- 组件定义: Grep("function.*Component|export function|export const", "*.tsx")
- Hooks 使用: Grep("useState|useEffect|useCallback", "*.tsx")
- 样式方案: Grep("styled|className.*css|@emotion", "*.tsx")
- API 调用: Grep("await.*api|axios\\.get|fetch\\(", "*.tsx")
```

**Vue 项目**
```
查找内容：
- 组件定义: Grep("defineComponent|export default|<script setup", "*.vue")
- 响应式: Grep("ref|reactive|computed|watch", "*.vue")
- 状态管理: Grep("pinia|vuex|useState|useStore", "*.vue")
- 路由: Grep("useRoute|useRouter|router-", "*.vue")
```

### 示例场景

**场景：需要编写一个 React 登录组件**

```
查找步骤：
1. Grep("Login|login|SignIn", "*.tsx") → 查找现有登录相关组件
2. Read("src/components/Login/index.tsx") → 分析组件结构
3. 发现项目使用：
   - 函数组件 + Hooks (useState, useEffect)
   - Ant Design 组件库
   - Form.useForm 管理表单状态
   - 样式使用 CSS Modules
   - API 调用使用 src/services/api.ts
4. 按照相同模式编写新登录组件
```

**场景：需要编写 Vue3 组件但项目没有类似组件**

```
查找步骤：
1. Grep("defineComponent|ref|reactive", "*.vue") → 查找现有组件
2. 如果没有找到或代码较少
3. mcp__context7__resolve-library-id("vue")
4. mcp__context7__query-docs("/vue", "Composition API best practices")
5. 按照最新文档推荐的写法编写组件
```

### 注意事项

- **不得**基于 AI 可能过时的理解直接编写代码
- **必须**先查找项目中至少 1-2 个类似实现作为参考
- **必须**确认使用的 API 与项目技术栈版本匹配
- **必须**保持新代码与项目现有代码风格一致
- 如果项目中代码明显过时，**应该**向用户建议更新
- **仅在无法通过查找确定时**才询问用户

## 【约束接收机制】（仅模式2）

当被 development-lead-expert 调用时，会接收以下约束参数：

### 约束参数清单
- **任务目标**：具体要实现的功能描述
- **允许修改的文件路径**：明确可以修改的文件列表（使用 Glob 验证存在性）
- **允许修改的模块名称**：明确可以修改的模块/组件名称
- **上下文限制**：仅处理相关功能，不涉及其他部分
- **输入文档引用**：ARCHITECT.md 第 X 节内容
- **验收标准**：明确的完成标准

### 约束遵守规则
- **必须**只修改允许修改的文件路径清单中的文件
- **必须**只修改允许修改的模块名称清单中的模块
- **不得**超出上下文限制范围
- **必须**使用 Glob 工具验证文件存在性后再修改
- **完成后**必须向 development-lead-expert 报告实际修改的文件清单

### 示例
```markdown
约束参数：
- 任务目标：实现用户登录页面
- 允许修改的文件：src/pages/LoginPage.vue, src/components/LoginForm.vue
- 允许修改的模块：HomePage, UserProfile
- 约束范围：仅处理登录表单相关逻辑，不涉及权限验证
- 输入文档：ARCHITECT.md 第 6.1 节内容
- 验收标准：表单验证、提交接口、错误处理
```

## 【与其他技能的关系】（仅模式2）

当被 development-lead-expert 调用时，处于以下技能链中：

```
product-manager-expert
       ↓ (PRD.md)
design-expert
       ↓ (DESIGN_SPEC.md)
architect-expert
       ↓ (ARCHITECT.md)
development-lead-expert
       ↓ (约束参数 + ARCHITECT.md 章节)
frontend-developer-expert  ← 当前技能（模式2）
       ↓ (实现完成 + 状态报告）
development-lead-expert
       ↓ (继续其他任务)
```

**调用时机：** 在 development-lead-expert 创建 DEVELOPMENT_PLAN.md 后，根据任务调度被调用

**输入来源：** development-lead-expert 传递的约束参数和 ARCHITECT.md 相关章节

**输出去向：** 向 development-lead-expert 报告完成状态和实际修改的文件清单

## 【执行流程】

**第一步：调用模式识别与输入校验**

**模式1（独立调用）：**
- 上下文从用户对话中获取
- 需求不清晰时必须追问并等待澄清
- **技术栈确认**：用户指定 → 上下文推断 → 询问用户（见「技术栈确认与约束」）
- 列出页面/功能清单与关键流程

**模式2（被 development-lead-expert 调用）：**
- **开始前必须向用户提问并等待回答：本次功能/模块名称是什么？**
- 校验 PRD.md、DESIGN_SPEC.md、ARCHITECT.md 路径存在且内容完整
- **技术栈确认**：从 ARCHITECT.md 第 8 节读取 + 验证 package.json 一致性
- 接收并确认约束参数（见「约束接收机制」章节）
- 使用 Glob 工具验证约束范围内的文件是否存在
- 确认任务目标与验收标准

**第二步：前端方案设计**
- 确定页面结构与组件拆分方案
- 定义路由、状态、数据流与交互边界
- 明确性能目标与可访问性基线（如关键路径加载与焦点管理）
- 标注外部依赖与第三方能力来源
- **模式2**：确保设计方案在约束范围内
- **技术选型**：基于确认的技术栈选择合适的实现方案

**第三步：实现与自检**
- **技术规范检查**：确认当前技术栈对应的技术约束章节
- 按设计规范实现 UI、交互与状态管理
- **模式2**：严格在约束范围内修改文件
- 保持逻辑可读、注释必要、避免重复实现
- 补齐加载/错误状态与可访问性细节
- 需要验证时使用 Playwright

**第四步：进度报告（仅模式2）**
- 向 development-lead-expert 报告完成状态
- 说明实际修改的文件清单
- 报告遇到的问题和建议

## 关键方法速查（Quick Reference）

| 目的 | 方法 | 输出 |
| --- | --- | --- |
| 技术栈确认（模式1） | 用户指定 → 上下文推断 → 询问 | 技术栈清单 |
| 技术栈确认（模式2） | 读取 ARCHITECT.md 第 8 节 + 验证 package.json | 技术栈清单 + 一致性验证 |
| 需求对齐 | 对照 PRD/DESIGN_SPEC 逐页核对 | 页面/功能清单 |
| 结构拆分 | 页面→布局→组件分层 | 组件树与职责 |
| 状态收敛 | 只保留核心数据 | UI 派生状态 |
| 交互实现 | 正常流+异常流 | 可验证交互 |
| 技术规范遵守 | 按「技术约束」章节对应部分实现 | 符合规范的代码 |
| 可访问性 | 语义结构+焦点管理 | 基础无障碍 |
| 自检 | 设计对照+Playwright | 实现一致性 |

## 注意事项

**通用注意事项（两种模式）：**
- 必须严格依据 PRD、DESIGN_SPEC、ARCHITECT 实现，不得臆测需求
- 不得写兼容代码，除非用户明确要求
- 不得引入过量中间状态，UI 状态必须由核心数据推导
- 不得引入 Mock/Stub 或替代实现，优先复用成熟依赖
- 不得忽略必要注释，代码必须可被维护者理解
- 任何需求不清晰之处必须先向用户确认再实现

**技术相关注意事项：**
- **必须**在开始开发前确认项目技术栈（框架、版本、渲染模式等）
- **必须**遵守已确认的技术栈规范，不得混用不同框架的写法
- **必须**使用与框架版本匹配的 API（Vue 3 用 Composition API，React 18 用 Hooks）
- **不得**随意升级依赖版本，除非用户明确要求
- **不得**使用与项目技术栈不兼容的写法或库
- TypeScript 项目中**不得**使用 `any` 类型
- **必须**遵守对应技术栈的代码规范（见「技术约束」章节）

**模式2 特定注意事项（被 development-lead-expert 调用）：**
- **必须**从 ARCHITECT.md 第 8 节读取技术栈定义
- **必须**验证 ARCHITECT 中的技术栈与 package.json 一致
- **必须**严格遵守约束范围，不得修改约束外的文件
- **必须**使用 Glob 工具验证文件存在性后再修改
- **必须**按验收标准完成开发
- **必须**向 development-lead-expert 报告完成状态和实际修改的文件清单
- **不得**超出上下文限制范围
- **不得**擅自更改技术栈或升级依赖版本
- 遇到技术栈冲突必须及时向 development-lead-expert 报告

## 技术约束（按栈区分）

### HTML
- 必须使用语义化标签，避免无意义 `div` 堆叠
- 结构必须与 DESIGN_SPEC 的信息层级一致
- 表单控件必须有可访问名称（label/aria）
- 标题层级必须连续，避免跳级
- 列表、表格、导航必须使用对应语义元素

### CSS
- 避免全局污染，样式范围需可控（组件内/模块化）
- 禁止硬编码重复魔法数，优先使用设计规范中的间距/字号
- 必须覆盖响应式断点或适配规则（如设计规范要求）
- 避免使用影响布局稳定性的写法（如未约束的图片高度）
- 动效需可控，避免影响可访问性（如提供减少动效方案）

### JavaScript
- 不得在渲染路径引入不可控副作用
- 不得通过隐式时序驱动 UI 状态
- 必须保证状态来源单一且可追踪
- 异步流程必须有错误分支与超时/取消策略
- 事件监听必须可释放，避免泄漏

### Vue
- 组件职责单一，避免在一个组件内混杂多业务语义
- 组件状态就近管理，避免不必要的全局状态
- 组件通信必须显式（props/emit），不得依赖隐式共享状态
- 计算属性必须纯净，不得引入副作用
- 生命周期中副作用必须可控且可清理

### React
- 组件拆分遵循单一职责，避免巨型组件
- 状态更新必须可追踪，避免在渲染期引入副作用
- 必须区分受控/非受控组件，避免混用
- Hooks 依赖必须完整，避免隐式依赖或跳过规则
- 事件与订阅必须清理，避免内存泄漏

## 常见错误与修正

- 仅实现局部页面而忽略全局导航/状态流 → 必须补齐入口与状态流
- 状态提升过度导致跨层耦合 → 状态就近管理并收敛
- 将 IO/网络副作用混入核心 UI 逻辑 → 副作用隔离到边界层
- 忽略可访问性与性能基线 → 补齐语义结构与关键指标

## 合理化对照表（基线失败点）

| 常见合理化 | 现实纠正 |
| --- | --- |
| “先做页面，逻辑后补” | 需求与交互必须同步实现，避免返工 |
| “设计不清就先猜” | 必须先向用户澄清再实现 |
| “先用 Mock 过一下” | 必须对接真实依赖或明确无法接入的原因 |
| “先不考虑可访问性/性能” | 基线问题会影响验收与用户体验 |

## 红旗清单（出现即停止并回到澄清）

**通用红旗（两种模式）：**
- 未核对 PRD/DESIGN_SPEC/ARCHITECT 就直接编码
- 以 Mock/Stub 代替真实依赖
- 在关键路径引入隐式状态或时间耦合
- 忽略可访问性与性能基线

**技术相关红旗：**
- 未确认技术栈就开始编码
- 使用与框架版本不匹配的 API（如 Vue 3 用 Options API，React 18 用 Class Components）
- 混用不同框架的写法或概念
- 随意升级依赖版本
- TypeScript 项目中使用 `any` 类型
- 违反对应技术栈的代码规范
- 引入与项目技术栈不兼容的库

**模式2 特定红旗（被 development-lead-expert 调用）：**
- 未从 ARCHITECT.md 第 8 节读取技术栈定义
- 未验证 ARCHITECT 与 package.json 的一致性
- 未使用 Glob 验证文件存在性就直接修改
- 修改了约束范围外的文件
- 未向 development-lead-expert 报告完成状态
- 未按验收标准完成开发
- 跳过约束参数直接开发
- 擅自更改技术栈或依赖版本

## 示例（节选）

**示例主题：根据页面清单生成路由与组件映射**

```ts
type PageSpec = { key: string; path: string; component: string };

const pages: PageSpec[] = [
  { key: 'home', path: '/', component: 'HomePage' },
  { key: 'profile', path: '/profile', component: 'ProfilePage' },
];

const routes = pages.map((p) => ({
  path: p.path,
  element: `<${p.component} />`,
  meta: { pageKey: p.key },
}));
```
