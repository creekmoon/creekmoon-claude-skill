# 动效实现技法

motion.md 决定"要不要动、多快、什么曲线"；本文件是决定之后的实现手段。写复杂交互（拖拽、手势、可中断动画、tab 指示器、揭示效果）时读，或者规则都对了但效果还是不对时来这里找手段。

常规过渡（hover、弹窗、下拉、toast）用 motion.md 就够了，不需要本文件。

## 弹簧还是曲线

默认用时长 + 缓动曲线。只有这四类场景值得上弹簧：

- 拖拽的惯性收尾（甩出去要有速度感）
- 可能被中途打断、反向的手势
- 需要"活着"的元素（灵动岛那类形变）
- 装饰性的鼠标跟随（视差、倾斜）

**弹簧的真正优势是中断时保留速度**：CSS transition 中断会重定向到新目标，keyframes 中断会从零重播，而弹簧带着当前速度平滑反向。展开一个卡片后立刻按 Esc，只有弹簧不会有"顿一下再往回走"的突兀感。

参数用 Apple 口径更好推理，需要精细控制再换物理口径：

```js
// 推荐：直觉可控
{ type: "spring", duration: 0.5, bounce: 0.2 }

// 需要精细控制时
{ type: "spring", mass: 1, stiffness: 100, damping: 10 }
```

- bounce 控制在 0.1-0.3；工作界面默认 0（无回弹），回弹只给拖拽甩出、移动端手势和低频的愉悦时刻。
- 鼠标位置直接映射到视觉变化（旋转、位移）会显得僵硬，因为真实物体不会瞬间到位——套一层 `useSpring` 让值带惯性。前提是这个动效**是装饰性的**；金融数据图表这种功能性内容，不加动画才是对的。

## 位移与形变技法

- **`translate` 的百分比相对元素自身尺寸**：`translateY(100%)` = 移动自身高度，与实际像素高度无关。抽屉藏到屏幕外、toast 从下方进场都用它，不要硬编码 px——内容变高时不会失效（Sonner 和 Vaul 就是这么做的）。
- **`scale()` 会连子元素一起缩放**（`width`/`height` 不会）。按钮按下时文字和图标同步缩小，正是想要的效果，不是 bug。
- **3D**：`transform-style: preserve-3d` 配 `rotateX/rotateY` 纯 CSS 就能做翻转、环绕、纵深。属于营销轨道的演出手段，产品界面不要碰。
- `transform-origin` 是所有形变的锚点，默认 center 对绝大多数悬浮层都是错的（见 motion.md 的空间规则）。组件库通常已经算好了触发点，直接用它暴露的变量：

```css
/* Radix UI */
.popover { transform-origin: var(--radix-popover-content-transform-origin); }
/* Base UI */
.popover { transform-origin: var(--transform-origin); }
```

## clip-path

`clip-path: inset(上 右 下 左)` 每个值从对应边"吃进"元素。可动画、走合成层、不需要额外 DOM，是被严重低估的动效工具。

- 基本形：`inset(0 100% 0 0)` 完全裁掉（从右往左揭示时的起点）→ `inset(0 0 0 0)` 完全显示。
- **tab 指示器的完美配色过渡**：复制一份 tab 列表，副本整体按激活态配色（不同底色、不同文字色），用 clip-path 只露出当前激活项，切 tab 时动画这个裁剪区。颜色是被"裁"出来的而不是过渡出来的，逐个属性做 color transition 永远达不到这种干净度。
- **长按删除**：彩色遮罩起始 `inset(0 100% 0 0)`，`:active` 时用 2s linear 推到 `inset(0 0 0 0)`，松手 200ms ease-out 弹回；按钮本身同时 `scale(0.97)`。
- **滚动揭示**：`inset(0 0 100% 0)` → `inset(0 0 0 0)`，用 `IntersectionObserver` 或 `useInView({ once: true, margin: '-100px' })` 触发。
- **图片对比滑块**：两张图叠放，上层 `inset(0 X% 0 0)`，X 跟随拖拽位置。零额外元素。

## 拖拽与手势

- **速度优先于距离**：不要只判断"拖过阈值才算数"。算 `velocity = |位移| / 耗时`，超过 ~0.11 就直接触发——快速轻扫一下也应该能划走。
- 拖拽一开始就 `setPointerCapture`，指针移出元素范围仍持续跟随，否则快速拖动会中途断掉。
- **多点触控保护**：拖拽进行中忽略新增触点（`if (isDragging) return`），否则中途换手指会让元素瞬移到新指针位置。
- **越界不硬停**：超出边界后按比例衰减位移（拖得越多动得越少）。现实里的东西不会撞上无形的墙，硬停会被当成 bug。
- 直接操纵过程中不加任何缓动（元素锁死跟随指针），松手后才允许弹簧或曲线归位。

## 实现选型

| 场景 | 用什么 | 原因 |
|------|--------|------|
| 预定序列、状态切换 | CSS transition / animation | 跑在合成线程，页面正在加载、主线程被占满时也不掉帧 |
| 需要 JS 控制但要 CSS 性能 | WAAPI `element.animate()` | 硬件加速、可中断、不需要动画库 |
| 动态值、手势驱动、可中断 | JS 动画库（Motion 等） | 需要运行时计算目标值 |

```js
element.animate([{ clipPath: 'inset(0 0 100% 0)' }, { clipPath: 'inset(0 0 0 0)' }], {
  duration: 1000,
  fill: 'forwards',
  easing: 'cubic-bezier(0.77, 0, 0.175, 1)',
});
```

- **Motion / Framer Motion 的简写属性 `x`、`y`、`scale` 不走硬件加速**，它们用 `requestAnimationFrame` 在主线程跑，页面同时在加载或渲染时会掉帧。要稳就写完整字符串：`animate={{ transform: "translateX(100px)" }}`。
- 同理，页面切换、tab 指示器这类"跳转瞬间正好在加载内容"的动画，优先用 CSS 而不是布局动画库。
- `filter: blur()` 控制在 20px 以内，重模糊很贵，Safari 尤其。

## 调试

- **慢放**：临时把时长调到 2-5 倍，或用 Chrome DevTools Animations 面板降速播放。重点看四件事：交叉淡入时能不能看见两个独立图层重叠、缓动有没有突然启停、`transform-origin` 是不是错的、多个属性有没有不同步。
- **逐帧**：DevTools 逐帧步进，能抓出全速下看不见的属性间时序错位。
- **真机测手势**：拖拽、滑动必须在物理设备上试（本机 IP 访问 dev server + Safari 远程调试），模拟器的手感不作数。
- **隔天再看**：当天调到"感觉没问题"的时序，第二天用新鲜眼睛常常一眼看出问题。动效值得留一次复看。
