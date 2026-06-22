# Prototype Generation Guide

Use this guide when the user requests a prototype. Generate single-file HTML
prototypes that can be opened directly in a browser.

## Tech Spec

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[产品名称] - 原型</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Custom styles only when Tailwind utilities insufficient */
    </style>
</head>
<body class="bg-gray-50">
    <!-- Page content -->
    <script>
        // Interaction logic
    </script>
</body>
</html>
```

## Design System Defaults

When no specific design system is provided, use these defaults:

### Colors
- **Background**: `bg-gray-50` (page), `bg-white` (cards)
- **Primary**: `bg-blue-600` / `text-blue-600` / `border-blue-600`
- **Text primary**: `text-gray-900`
- **Text secondary**: `text-gray-500`
- **Text muted**: `text-gray-400`
- **Error**: `bg-red-50` / `text-red-600` / `border-red-200`
- **Success**: `bg-green-50` / `text-green-600`
- **Border**: `border-gray-200`

### Typography
- **Page title**: `text-2xl font-bold text-gray-900`
- **Section title**: `text-lg font-semibold text-gray-900`
- **Body**: `text-sm text-gray-600` or `text-base text-gray-700`
- **Caption/label**: `text-xs text-gray-500 uppercase tracking-wide`
- **Button text**: `text-sm font-medium`

### Spacing
- **Card padding**: `p-6`
- **Card gap**: `gap-4` or `gap-6`
- **Section margin**: `mb-6` or `mb-8`
- **Max content width**: `max-w-md` (mobile), `max-w-lg` (tablet), `max-w-7xl` (desktop)

### Border Radius
- **Cards**: `rounded-lg`
- **Buttons**: `rounded-md`
- **Inputs**: `rounded-md`
- **Avatars**: `rounded-full`
- **Tags/badges**: `rounded-full`

---

## Essential Components

### Navigation Bar
```html
<nav class="fixed top-0 w-full bg-white border-b border-gray-200 z-50">
    <div class="max-w-7xl mx-auto px-4 h-14 flex items-center justify-between">
        <div class="font-bold text-lg">Logo</div>
        <div class="flex gap-6 text-sm text-gray-600">
            <a href="#" class="hover:text-gray-900">Nav Item</a>
        </div>
    </div>
</nav>
```

### Card Container
```html
<div class="bg-white rounded-lg border border-gray-200 p-6 shadow-sm">
    <!-- Card content -->
</div>
```

### Primary Button
```html
<button class="w-full bg-blue-600 text-white rounded-md py-2.5 px-4 text-sm font-medium
    hover:bg-blue-700 active:bg-blue-800 transition-colors">
    Button Text
</button>
```

### Secondary Button
```html
<button class="w-full bg-white text-gray-700 border border-gray-300 rounded-md py-2.5 px-4
    text-sm font-medium hover:bg-gray-50 active:bg-gray-100 transition-colors">
    Button Text
</button>
```

### Text Input
```html
<div>
    <label class="block text-sm font-medium text-gray-700 mb-1">Label</label>
    <input type="text" placeholder="Placeholder text"
        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm
        focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent
        placeholder:text-gray-400">
    <p class="mt-1 text-xs text-red-600 hidden" id="error-msg">Error message</p>
</div>
```

### Form Validation (JavaScript)
```javascript
function validateEmail(input) {
    const error = input.parentElement.querySelector('.error-msg');
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input.value)) {
        error.classList.remove('hidden');
        input.classList.add('border-red-300', 'focus:ring-red-500');
        return false;
    }
    error.classList.add('hidden');
    input.classList.remove('border-red-300', 'focus:ring-red-500');
    return true;
}
```

### Loading State (Button)
```javascript
function setLoading(button, loading = true) {
    if (loading) {
        button.disabled = true;
        button.dataset.originalText = button.textContent;
        button.innerHTML = `<svg class="animate-spin h-4 w-4 inline mr-2" viewBox="0 0 24 24">
            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none" opacity="0.25"/>
            <path fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
        </svg>Processing...`;
    } else {
        button.disabled = false;
        button.textContent = button.dataset.originalText;
    }
}
```

### Toast Notification
```javascript
function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    const colors = {
        success: 'bg-green-600',
        error: 'bg-red-600',
        warning: 'bg-yellow-600'
    };
    toast.className = `fixed top-4 right-4 px-4 py-3 rounded-lg text-white text-sm
        ${colors[type] || colors.success} shadow-lg z-50 transition-opacity duration-300`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}
```

### Modal/Dialog
```html
<div id="modal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50 p-4">
    <div class="bg-white rounded-lg max-w-md w-full p-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-2">Title</h3>
        <p class="text-sm text-gray-600 mb-4">Description text.</p>
        <div class="flex gap-3 justify-end">
            <button onclick="closeModal()" class="px-4 py-2 text-sm text-gray-600 hover:text-gray-900">Cancel</button>
            <button onclick="confirmAction()" class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700">Confirm</button>
        </div>
    </div>
</div>
```

### Tab Switching
```javascript
function switchTab(tabId) {
    document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
    document.querySelectorAll('.tab-btn').forEach(el => {
        el.classList.remove('border-blue-600', 'text-blue-600');
        el.classList.add('border-transparent', 'text-gray-500');
    });
    document.getElementById(tabId).classList.remove('hidden');
    event.target.classList.add('border-blue-600', 'text-blue-600');
    event.target.classList.remove('border-transparent', 'text-gray-500');
}
```

### Responsive Grid
```html
<!-- Cards grid -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
    <div class="bg-white rounded-lg border p-4">Card 1</div>
    <div class="bg-white rounded-lg border p-4">Card 2</div>
    <div class="bg-white rounded-lg border p-4">Card 3</div>
</div>
```

### Mobile-First Layout
```html
<!-- Single column mobile, side-by-side desktop -->
<div class="flex flex-col md:flex-row gap-4">
    <div class="w-full md:w-1/3">Sidebar</div>
    <div class="w-full md:flex-1">Main content</div>
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

---

## Prototype Principles

1. **Single file**: Everything in one HTML file (HTML + CSS + JS + mock data)
2. **No build step**: Open directly in browser, no npm install
3. **Interactive**: Buttons work, forms validate, tabs switch, modals open
4. **Responsive**: Works on mobile (375px) through desktop (1440px)
5. **Clean data**: Use realistic mock data, not "lorem ipsum" or "test1/test2"
6. **No emojis as icons**: Use inline SVG or text labels
7. **Accessibility basics**: `alt` on images, `label` on inputs, keyboard focus styles

## Responsive Breakpoints

| Breakpoint | Width | Usage |
|------------|-------|-------|
| Default | < 640px | Mobile. Stack everything vertically. Full-width buttons. Bottom nav if needed. |
| `sm:` | >= 640px | Large phones |
| `md:` | >= 768px | Tablet. Side-by-side layouts begin. |
| `lg:` | >= 1024px | Desktop. Full layouts, sidebars, multi-column grids. |
| `xl:` | >= 1280px | Large desktop. Max content width applied. |
