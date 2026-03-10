#!/usr/bin/env python3
"""
初始化 Agent Memory V3 文档结构。

使用方法:
    python init-memory.py [项目根目录]

如果不指定目录，则在当前目录创建 .agent-memory/ 结构。
"""

import shutil
import sys
from pathlib import Path
from typing import Optional


TEMPLATES = {
    ".agent-memory/00-index.md": "assets/root-index-template.md",
    ".agent-memory/01-system/index.md": "assets/system-index-template.md",
    ".agent-memory/01-system/context.md": "assets/system-context-template.md",
    ".agent-memory/01-system/architecture.md": "assets/system-architecture-template.md",
    ".agent-memory/01-system/tech-stack.md": "assets/system-tech-stack-template.md",
    ".agent-memory/01-system/data-model.md": "assets/system-data-model-template.md",
    ".agent-memory/01-system/conventions.md": "assets/system-conventions-template.md",
    ".agent-memory/01-system/lookup.md": "assets/system-lookup-template.md",
    ".agent-memory/02-modules/index.md": "assets/modules-index-template.md",
}

EXTRA_DIRS = [
    ".agent-memory/01-system",
    ".agent-memory/02-modules",
]


def get_skill_dir() -> Path:
    return Path(__file__).resolve().parent.parent


def ensure_directory(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def copy_template(skill_dir: Path, target_dir: Path, target_file: str, template_file: str) -> bool:
    template_path = skill_dir / template_file
    target_path = target_dir / target_file

    if not template_path.exists():
        print(f"[ERROR] 模板文件不存在: {template_path}")
        return False

    ensure_directory(target_path.parent)
    shutil.copy2(template_path, target_path)
    print(f"[OK] 创建: {target_path}")
    return True


def build_readme() -> str:
    return """# Agent Memory V3

面向 LLM 的目录式项目记忆结构。设计原则是单入口、逐级目录跳转、渐进式披露。

## 目录结构

```
.agent-memory/
├── 00-index.md
├── 01-system/
│   ├── index.md
│   ├── context.md
│   ├── architecture.md
│   ├── tech-stack.md
│   ├── data-model.md
│   ├── conventions.md
│   └── lookup.md
├── 02-modules/
│   ├── index.md
│   └── mod-*.md
└── 02-modules/{module}/
    └── topic-*.md
```

## 默认阅读顺序

1. `00-index.md`
2. `01-system/index.md` 或 `02-modules/index.md`
3. `01-system/lookup.md` 或 `02-modules/mod-*.md`
4. `02-modules/{module}/topic-*.md`

## 效率规则

1. 新查询默认从 `00-index.md` 开始
2. 如果当前轮已经由父级 index 明确定位到子路径，可直接继续读取该子路径
3. 不在未知路径下猜测性直达叶子

## 维护要求

1. 只写经代码验证的事实
2. 每次新增模块或主题文档时，同步更新 `00-index.md`、`01-system/lookup.md`、`02-modules/index.md`
3. 目录块只导航，内容块只承载事实
4. `lookup.md` 默认保持单文件；`mod-*.md` 不展开主题内部逻辑；`topic-*.md` 保持单主题边界
"""


def build_gitignore() -> str:
    return """# Agent Memory
# 这个目录通常建议提交到版本控制
# 如果不想提交，可取消下面注释
# *.md
"""


def init_memory(project_dir: Optional[str] = None) -> None:
    target_dir = Path(project_dir).resolve() if project_dir else Path.cwd()

    if not target_dir.exists():
        print(f"[ERROR] 目标目录不存在: {target_dir}")
        sys.exit(1)

    print(f"[INFO] 初始化 Agent Memory V3 到: {target_dir}")
    print("-" * 60)

    skill_dir = get_skill_dir()
    memory_root = target_dir / ".agent-memory"
    ensure_directory(memory_root)

    for extra_dir in EXTRA_DIRS:
        ensure_directory(target_dir / extra_dir)

    readme_path = memory_root / "README.md"
    readme_path.write_text(build_readme(), encoding="utf-8")
    print(f"[OK] 创建: {readme_path}")

    success_count = 0
    for target_file, template_file in TEMPLATES.items():
        if copy_template(skill_dir, target_dir, target_file, template_file):
            success_count += 1

    gitignore_path = memory_root / ".gitignore"
    gitignore_path.write_text(build_gitignore(), encoding="utf-8")
    print(f"[OK] 创建: {gitignore_path}")

    print("-" * 60)
    print(f"[INFO] 初始化完成，共创建 {success_count + 2} 个文件")
    print("[INFO] 下一步:")
    print("  1. 先填写 .agent-memory/00-index.md")
    print("  2. 再完善 01-system/index.md 和 01-system/lookup.md")
    print("  3. 按业务领域创建 02-modules/mod-*.md")
    print("  4. 仅在需要时补 02-modules/{module}/topic-*.md")
    print(f"[INFO] 首跳入口: {memory_root / '00-index.md'}")


def main() -> None:
    if len(sys.argv) > 1:
        if sys.argv[1] in ("-h", "--help"):
            print(__doc__)
            sys.exit(0)
        init_memory(sys.argv[1])
        return

    init_memory()


if __name__ == "__main__":
    main()
