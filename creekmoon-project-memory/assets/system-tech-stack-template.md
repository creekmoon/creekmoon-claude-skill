---
layer: system
doc_type: tech-stack
module: global
topic: tech-stack
aliases:
  - stack
  - dependencies
symbols:
  - `{package.json}`
  - `{pom.xml}`
related:
  - index.md
  - architecture.md
  - data-model.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# 技术栈

> 记录系统依赖什么运行、构建、存储和集成能力。

## 1. Runtime Stack

| Category | Technology | Version | Purpose |
|----------|------------|---------|---------|
| Language | {language} | {version} | {用途} |
| Framework | {framework} | {version} | {用途} |
| Build Tool | {build-tool} | {version} | {用途} |

## 2. Storage and Middleware

| Category | Technology | Version | Purpose |
|----------|------------|---------|---------|
| Database | {database} | {version} | {用途} |
| Cache | {cache} | {version} | {用途} |
| Message Queue | {mq} | {version} | {用途} |
| Search | {search} | {version} | {用途} |

## 3. Ops and Delivery

| Category | Technology | Purpose |
|----------|------------|---------|
| Container | {docker} | {用途} |
| Orchestration | {k8s} | {用途} |
| Monitoring | {observability} | {用途} |

## 4. Important Config Anchors

| Config | File | Why It Matters |
|--------|------|----------------|
| `{config-key}` | `{path}` | {说明} |
| `{config-key}` | `{path}` | {说明} |

## 5. Retrieval Keywords

`{tech}` / `{version}` / `{dependency}` / `{config-key}` / `{build-file}`

## 6. Navigation

- ↑ 上级: [System Index](index.md)
- ← 相关: [architecture.md](architecture.md)
- → 相关: [data-model.md](data-model.md)
