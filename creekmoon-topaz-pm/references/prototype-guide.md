# Prototype Generation Guide

Use this guide when the user requests a prototype. Generate single-file HTML
prototypes that can be opened directly in a browser.

## Positioning: Low-Fidelity on Purpose

A PM prototype communicates **structure, flows, and states** — what screens
exist, what the user can do, what happens next. It is NOT a visual design
deliverable: it makes no claims about colors, typography, spacing systems, or
brand. Visual design happens downstream, by whoever owns design execution.

Therefore prototypes are **grayscale wireframes**:

- Neutral grays only (white / gray backgrounds, gray borders, near-black
  text). No brand color, no accent color. If a state needs semantic emphasis
  (error, success), use text labels like `[错误]` or a darker gray — never a
  color decision that could be mistaken for a design choice.
- Default system fonts, plain rectangles, minimal rounding. The rougher it
  looks, the clearer it is that layout and styling are still open questions.
- Realistic content and working interactions — fidelity goes into the flow,
  not the paint.

This keeps the prototype honest: reviewers discuss flows and scope instead of
debating button colors, and the design phase starts from requirements rather
than from an accidental de-facto design.

## Tech Spec

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[产品名称] - 线框原型</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 text-gray-900">
    <!-- Wireframe content: gray-scale utilities only -->
    <script>
        // Interaction logic: state switching, flow navigation, mock data
    </script>
</body>
</html>
```

Constrain Tailwind usage to the gray scale (`bg-white`, `bg-gray-*`,
`text-gray-*`, `border-gray-*`). Buttons are bordered rectangles; the primary
action of a screen may use `bg-gray-800 text-white` so hierarchy is readable,
but nothing beyond that.

## What Every Prototype Must Demonstrate

1. **Every screen in the flow** — including the ones that only appear on
   error or empty paths.
2. **Every state from the State Definitions section** — default, loading,
   empty, success, error, partial error. Add visible dev-only controls
   ("模拟：加载失败") so reviewers can trigger each state without luck.
3. **The happy path end to end** — clicking through the primary flow must
   actually work with mock data.
4. **Recovery paths** — what the user clicks when something goes wrong.

If a screen or state exists in the PRD but not in the prototype, that's a gap.

## Building Blocks

### Screen / Flow Switching
```javascript
function showScreen(id) {
    document.querySelectorAll('.screen').forEach(el => el.classList.add('hidden'));
    document.getElementById(id).classList.remove('hidden');
}
```

### State Switching (per screen)
```javascript
// Each screen owns containers like #list-default, #list-loading, #list-empty,
// #list-error. Dev-only buttons call setState('list', 'error') to preview.
function setState(screen, state) {
    document.querySelectorAll(`[id^="${screen}-"]`).forEach(el => el.classList.add('hidden'));
    document.getElementById(`${screen}-${state}`).classList.remove('hidden');
}
```

### Wireframe Placeholder
```html
<!-- Image/chart placeholder: crossed box, never a real illustration -->
<div class="border border-gray-400 bg-gray-50 h-32 flex items-center justify-center text-gray-400 text-sm">
    [图表：近30天转化趋势]
</div>
```

### Mock Data Pattern
```javascript
const mockData = {
    users: [
        { id: 1, name: 'Alice', email: 'alice@example.com', role: 'Admin', status: 'active' },
        { id: 2, name: 'Bob', email: 'bob@example.com', role: 'Editor', status: 'active' },
        { id: 3, name: 'Carol', email: 'carol@example.com', role: 'Viewer', status: 'inactive' },
    ]
};
```

## Prototype Principles

1. **Single file**: Everything in one HTML file (HTML + CSS + JS + mock data)
2. **No build step**: Open directly in browser, no npm install
3. **Interactive**: Buttons work, forms validate, flows navigate, states switch
4. **Responsive enough**: Usable at mobile (375px) and desktop (1440px) widths —
   demonstrate that the flow survives a small screen, without committing to a
   layout system
5. **Clean data**: Use realistic mock data, not "lorem ipsum" or "test1/test2"
6. **No visual design**: grayscale only, no icons libraries, no illustrations,
   no motion beyond instant show/hide — leave every visual decision open
7. **Accessibility basics**: `label` on inputs, keyboard-reachable actions,
   semantic HTML — these are requirements, not styling
