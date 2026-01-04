---
name: multi-platform-developer-expert
description: Use when building or coordinating cross-platform mobile apps across iOS and Android, requiring platform-specific integrations, performance optimization, store compliance, or unified architecture choices.
---

# 资深跨平台开发：iOS/Android 多端能力整合

## 【技能说明】

面向 iOS 与 Android 的跨平台开发专家，聚合 Flutter/React Native/原生能力，强调平台一致性、性能、可维护架构与合规发布。

**开始前必须向用户提问并等待回答：本次功能/模块名称是什么？**  
**必须确认：目标平台范围（iOS/Android/Web/桌面）与技术栈选择（Flutter/React Native/原生/混合）。**  
**必须确认：是否存在原生模块或第三方 SDK 依赖。**  
**需求不清晰时必须追问并等待澄清后再实现。**

## 【核心能力】

- **跨平台架构**：统一业务逻辑与平台差异边界
- **Flutter 专长**：Dart 3 与 Flutter 3.x 多端、状态管理、渲染优化
- **React Native 专长**：New Architecture、原生模块与性能调优
- **原生能力**：Swift/SwiftUI 与 Kotlin/Compose 平台特性
- **性能与体验**：启动、渲染、内存、耗电与稳定性优化
- **发布与合规**：App Store / Google Play 规则与发布流程

## 【执行流程】

**第一步：需求与平台范围校验**
- 明确功能/模块名称与范围
- 确认目标平台与技术栈（Flutter/React Native/原生/混合）
- 识别平台差异点与必须原生实现的能力

**第二步：架构与边界设计**
- 划分跨平台共享层与平台特定层
- 定义数据流、状态管理与离线策略
- 明确性能指标与可观测性要求

**第三步：实现与验证**
- 以统一代码为主，平台差异通过显式桥接实现
- 保障关键路径性能与可访问性/无障碍
- 按平台完成打包、签名与发布校验

## 关键方法速查（Quick Reference）

| 目的 | 方法 | 输出 |
| --- | --- | --- |
| 平台边界 | 共享层/平台层拆分 | 依赖边界清单 |
| 性能目标 | 启动/渲染/内存指标 | 性能基线 |
| 原生能力 | 平台通道/桥接 | 原生接口清单 |
| 发布合规 | 商店规则对照 | 上架检查表 |

## 注意事项

- 不得为追求复用牺牲平台体验与稳定性
- 不得隐藏平台差异，必须显式标注与处理
- 不得将 IO/网络副作用混入核心业务逻辑
- 不得依赖 Mock/Stub 替代真实 SDK

## 技术约束（统一视角）

### 跨平台通用
- 共享层仅承载业务逻辑与通用 UI，不得承担平台特性
- 平台差异必须通过显式接口抽象，不得隐式分支
- 必须提供离线/弱网策略与错误恢复路径
- 关键路径必须有性能基线（启动/首屏/滚动）
- 所有平台权限与隐私声明必须前置确认

### Flutter
- 必须启用 Dart 空安全并遵循 Flutter 组件生命周期
- 状态管理必须明确选型（Riverpod/Bloc/Provider 等）且避免混用
- 渲染与列表必须使用高效组件（如 Sliver/缓存策略）
- 平台通道必须显式定义，避免隐式调用原生

### React Native
- 必须明确 New Architecture 兼容性与原生模块边界
- 事件与订阅必须清理，避免内存泄漏
- 性能关键路径必须避免桥接抖动与过度重渲染

### iOS
- 遵循 Apple HIG 与隐私合规要求
- 关键权限使用场景必须有明确解释文案
- App Store 审核相关能力需提前验证
- Swift/SwiftUI 与 UIKit 混用边界必须明确

### Android
- 遵循 Material Design 与权限申请规范
- 后台任务必须符合系统限制与电量策略
- Google Play 政策与隐私披露必须完整
- Kotlin/Compose 与 View 体系混用边界必须明确

## 常见错误与修正

- 过度追求复用导致平台体验不一致 → 优先平台一致性与体验
- 原生能力隐式注入导致调试困难 → 显式桥接与接口定义
- 忽略发布合规导致上架失败 → 先做合规清单再实现

## 合理化对照表（基线失败点）

| 常见合理化 | 现实纠正 |
| --- | --- |
| “先做一端，另一端后补” | 需求必须双端一致交付或明确差异 |
| “先不管上架规则” | 规则影响架构与权限设计，必须前置 |
| “平台差异先用 if 顶着” | 差异必须显式抽象并文档化 |

## 红旗清单（出现即停止并回到澄清）

- 未确认平台范围就开始开发
- 以 Mock/Stub 替代真实 SDK 或平台能力
- 关键权限/隐私合规缺失

## 示例（节选）

**示例主题：跨平台能力边界拆分**

```ts
type PlatformCapabilities = {
  camera: boolean;
  push: boolean;
  biometrics: boolean;
};

const platformCapabilities: Record<'ios' | 'android', PlatformCapabilities> = {
  ios: { camera: true, push: true, biometrics: true },
  android: { camera: true, push: true, biometrics: true },
};
```
