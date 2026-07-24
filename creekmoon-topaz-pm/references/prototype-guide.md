# Prototype Generation Guide

Use this guide when the user requests a prototype. Generate single-file HTML
prototypes that can be opened directly in a browser.

## Positioning: Structural Source of Truth, Visually Blank on Purpose

A PM prototype is the **structural source of truth**: it commits to the
decisions made in `references/structure.md` — page form, layout skeleton,
information zoning, screen inventory, flows, and states. What it deliberately
does NOT commit to is visual design: it makes no claims about colors,
typography, spacing systems, or brand. Visual execution happens downstream (a
human designer or creekmoon-aglaea-design), on top of this structure —
enhancing it, not renegotiating it.

Therefore prototypes are **grayscale wireframes**:

- Neutral grays only (white / gray backgrounds, gray borders, near-black
  text). No brand color, no accent color. If a state needs semantic emphasis
  (error, success), use text labels like `[错误]` or a darker gray — never a
  color decision that could be mistaken for a design choice.
- Default system fonts, plain rectangles, minimal rounding. The rougher it
  looks, the clearer it is that styling is still an open question — the
  structure, however, is decided here and not up for renegotiation.
- Realistic content and working interactions — fidelity goes into structure
  and flow, not the paint.

This keeps the prototype honest: reviewers discuss structure, flows and scope
instead of debating button colors, and the design phase starts from a fixed
structure with open paint, rather than renegotiating both.

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

1. **The chosen structure** — each screen laid out per the page form, layout
   skeleton, and information zoning decided in structure.md.
2. **Every screen in the flow** — including the ones that only appear on
   error or empty paths.
3. **Every state from the State Definitions section** — default, loading,
   empty, success, error, partial error. Add visible dev-only controls
   ("模拟：加载失败") so reviewers can trigger each state without luck.
4. **The happy path end to end** — clicking through the primary flow must
   actually work with mock data.
5. **Recovery paths** — what the user clicks when something goes wrong.

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
   demonstrate that the chosen skeleton survives a small screen (sidebar
   collapses, tables scroll or drop columns)
5. **Clean data**: Use realistic mock data, not "lorem ipsum" or "test1/test2"
6. **No visual design**: grayscale only, no icons libraries, no illustrations,
   no motion beyond instant show/hide — leave every visual decision open
7. **Accessibility basics**: `label` on inputs, keyboard-reachable actions,
   semantic HTML — these are requirements, not styling
