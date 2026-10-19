---
name: docs-digest
description: Turn a documentation link into one easy-to-read HTML digest that explains each topic as What / Why / How with FAQs, for beginners. Use whenever the user shares a docs URL (library, API, tool, framework docs) and wants it summarized, explained, read for them ("đọc giúp", "tóm tắt", "giải thích dễ hiểu"), or turned into a cheat sheet or study notes, even if they never mention HTML.
---

# Docs Digest

Read a documentation page or site and produce a single self-contained HTML file built from `assets/template.html`.

## 1. Read the docs

1. Fetch the URL with WebFetch. Ask for the full content and the page's outline, not a summary, plus each heading's anchor (its `id` or `#slug` link) so source links can point at the exact part.
2. If the page is an index or landing page of a docs site, also fetch the child pages that matter for a newcomer, at most about 10 pages in total. Priority: Getting Started / Installation, Core Concepts, main API or usage guides. Skip changelogs, blog posts, and migration guides unless the user asks.
3. Keep a list of every page actually read (URL and title). Pages that fail to load are listed as failed, not silently dropped.

## 2. Plan the sections

- Start from the structure of the original docs, then merge or reorder for a beginner: concepts → installation → basic usage → advanced.
- Aim for 4–10 sections. Each section maps to one or more source pages or anchors.

## 3. Write each section

Every section has three labeled blocks, then FAQs, then a source link.

- **What (Là gì):** 1–2 plain sentences. Explain each term the first time it appears.
- **Why (Tại sao cần):** the problem it solves, when to use it and when not to, and a short comparison with alternatives if the docs mention one.
- **How (Dùng thế nào):** the key steps or code examples. Shorten long examples and add brief comments.
- **FAQ:** 2–4 questions in `<details>` / `<summary>`. Every answer must come from the docs.
- **Source link:** "Xem docs gốc" pointing at the exact source page plus the heading anchor (`page#anchor`). Fall back to the page URL only when no anchor was found.

Ground rules:
- Never go beyond the docs. Where the docs are silent (often the Why), write `docs không đề cập` with the `missing` class instead of guessing.
- Output language follows the language the user wrote in (default Vietnamese). Keep API names, function names, and technical terms in English.
- Escape `<`, `>` and `&` inside code blocks.

## 4. Build the HTML

Copy `assets/template.html` (in this skill's directory) and change only the content. Do not edit the CSS or JS.

1. Replace the `{{...}}` placeholders:

   | Placeholder | Vietnamese value | English value |
   |---|---|---|
   | `{{LANG}}` | `vi` | `en` |
   | `{{TITLE}}` | docs name + " — tóm tắt" | docs name + " — digest" |
   | `{{SOURCE_URL}}` | the URL the user gave | same |
   | `{{DATE}}` | today, `YYYY-MM-DD` | same |
   | `{{OVERVIEW_WHAT}}` / `WHY` / `HOW` | one line each for the whole docs | same |
   | `{{MENU_LABEL}}` / `{{TOC_LABEL}}` | `Mục lục` | `Contents` |
   | `{{SOURCE_LABEL}}` | `Nguồn` | `Source` |
   | `{{WHAT_LABEL}}` / `WHY` / `HOW` | `Là gì` / `Tại sao cần` / `Dùng thế nào` | `What it is` / `Why it matters` / `How to use it` |
   | `{{NOT_COVERED}}` | `docs không đề cập` | `not covered in the docs` |
   | `{{SOURCE_LINK_LABEL}}` | `Xem docs gốc` | `View original docs` |
   | `{{PAGES_READ_LABEL}}` | `Các trang đã đọc` | `Pages read` |

2. Replace everything between each pair of markers, keeping the markers themselves:
   - `<!-- TOC:START -->` … `<!-- TOC:END -->`: one `<li>` per section, with a nested `<ul>` of its FAQ links.
   - `<!-- SECTIONS:START -->` … `<!-- SECTIONS:END -->`: one `<section>` per section, copying the example's markup.
   - `<!-- PAGES:START -->` … `<!-- PAGES:END -->`: one `<li>` per page read.

3. IDs must match between the TOC and the content: sections are `s-1`, `s-2`, …; FAQs are `s-1-faq-1`, `s-1-faq-2`, … The JS uses them for smooth scrolling, the scrollspy highlight, and opening a FAQ from the TOC.

4. Allowed markup inside blocks: `<p>`, `<ul>`/`<ol>`, `<code>`, `<pre><code>`, `<strong>`, `<a>`, `<table>`. No external images, fonts, scripts, or CDNs.

## 5. Save and report

1. Save to `./docs-digest/<slug>.html` in the current project. The slug is the docs name in lowercase kebab-case, for example `zod-basic-usage`. Create the folder if needed.
2. Open it in the browser if possible (`xdg-open` on Linux, `open` on macOS, `start` on Windows). If that fails, just print the path.
3. Reply with:
   - the absolute file path
   - the list of pages read (and any that failed)
   - any section where the docs were thin, so the user knows where the digest is limited
