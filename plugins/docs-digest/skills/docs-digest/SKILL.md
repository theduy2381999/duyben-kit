---
name: docs-digest
description: Turn a documentation link into one easy-to-read HTML study page for beginners, with a 30-second summary, a colour-coded keyword sheet, plain explanations, "remember" notes per section, and an auto recap. Use whenever the user shares a docs URL (library, API, tool, framework, course) and wants it summarized, explained, read for them ("đọc giúp", "tóm tắt", "giải thích dễ hiểu"), or turned into a cheat sheet or study notes, even if they never mention HTML.
---

# Docs Digest

Read a documentation page or site and produce a single HTML study page built from `assets/template.html`. The goal is the easiest possible read for a newcomer.

## 1. Read the docs

1. Fetch the URL with WebFetch. Ask for the full content and outline, not a summary, plus each heading's anchor (its `id` or `#slug` link).
2. If the page is an index, landing page, or course outline, also fetch the child pages that matter for a newcomer, at most about 10 pages in total. Priority: Getting Started / Installation, Core Concepts, main API or usage guides. Skip changelogs, blog posts, and migration guides unless the user asks.
3. Keep a list of every page actually read (URL and title). List pages that fail to load as failed.

## 2. Plan

- **Sections:** 4–10, ordered for a beginner (big picture → setup → basic use → advanced). Merge or reorder the original structure freely.
- **Keywords:** pick 5–12 terms the reader must learn to understand the docs (concepts, key API names). Give each a short id (`tool`, `mcp-server`) and a one-sentence plain definition.
- **30-second summary:** 3–5 points that give the whole picture.

## 3. Write for the easiest read

- Short sentences, one idea per paragraph, everyday words. Explain like to a smart friend who is new to the topic.
- Prefer lists, numbered steps, and small tables over long paragraphs.
- Use concrete examples from the docs in an `.example` box. An everyday analogy is allowed only to illustrate something the docs actually say; never use it to add facts.
- Code: only the essential lines, with short comments. Escape `<`, `>` and `&`.
- **Keywords:** wrap every mention of a keyword, in every part of the page, as `<span class="kw" data-kw="ID">term</span>` with the same id. The page gives each keyword one fixed colour and shows its definition on hover or tap, so consistent wrapping is what makes them easy to remember. Don't wrap inside code blocks or headings.
- **Cần nhớ (remember):** end each section with 1–3 bullets: the facts a reader should still know tomorrow. The recap at the bottom is built from these automatically, so make each bullet stand on its own.
- **FAQ (optional):** 0–3 questions a beginner would ask, in `<details>`, answered from the docs.
- **Source link:** "Xem docs gốc" pointing at `page#anchor`; fall back to the page URL when no anchor was found.
- Never go beyond the docs. Where the docs are silent on something a reader would expect, say `docs không đề cập` with the `missing` class.
- Output language follows the user's language (default Vietnamese). Keep API names, function names, and technical terms in English.

## 4. Build the HTML

Copy `assets/template.html` (in this skill's directory) and change only the content. Do not edit the CSS or JS.

1. Replace the `{{...}}` placeholders:

   | Placeholder | Vietnamese value | English value |
   |---|---|---|
   | `{{LANG}}` | `vi` | `en` |
   | `{{TITLE}}` / `{{DOCS_NAME}}` | the docs name only (e.g. `Zod`) | same |
   | `{{DIGEST_LABEL}}` | `Tóm tắt docs` | `Docs digest` |
   | `{{SOURCE_URL}}` | the URL the user gave | same |
   | `{{DATE}}` | today, `YYYY-MM-DD` | same |
   | `{{SOURCE_LABEL}}` | `Nguồn` | `Source` |
   | `{{MENU_LABEL}}` / `{{TOC_LABEL}}` | `Mục lục` | `Contents` |
   | `{{TLDR_LABEL}}` | `Đọc trong 30 giây` | `The 30-second version` |
   | `{{KEYWORDS_LABEL}}` | `Từ khoá cần biết` | `Key terms` |
   | `{{EXAMPLE_LABEL}}` | `Ví dụ` | `Example` |
   | `{{REMEMBER_LABEL}}` | `Cần nhớ` | `Remember` |
   | `{{RECAP_LABEL}}` | `Ôn tập nhanh` | `Quick recap` |
   | `{{SOURCE_LINK_LABEL}}` | `Xem docs gốc` | `View original docs` |
   | `{{PAGES_READ_LABEL}}` | `Các trang đã đọc` | `Pages read` |

2. Replace everything between each pair of markers, keeping the markers:
   - `TLDR`: one `<li>` per summary point.
   - `KEYWORDS`: one `.kw-entry` per keyword, with `id="kw-ID"` and `data-kw="ID"`, a `.kw-term` and a `.kw-def`.
   - `TOC`: one `<li class="num"><a href="#s-N">Title</a></li>` per section.
   - `SECTIONS`: one `<section class="section" id="s-N">` per section, copying the example's markup. `.section-num` is `01`, `02`, … Drop the `.example`, `pre` or `.faq` parts a section doesn't need. FAQ ids are `s-N-faq-M`.
   - `PAGES`: one `<li>` per page read.
   The recap section stays empty; the page fills it from the "remember" lists.

3. Allowed markup in sections: `<p>`, `<ul>`/`<ol>`, `<code>`, `<pre><code>`, `<strong>`, `<a>`, `<table>` (wrap wide tables in `<div class="table-wrap">`), `.example`, `.kw`. No external images, scripts, or CDNs. The only external request is the template's Google Fonts link; its fallback stacks keep the page readable offline.

## 5. Save and report

1. Save to `./docs-digest/<slug>.html` in the current project. The slug is the docs name in lowercase kebab-case. Create the folder if needed.
2. Open it in the browser if possible (`xdg-open` on Linux, `open` on macOS, `start` on Windows). If that fails, just print the path.
3. If the Artifact tool is available, also publish it as an artifact:
   - Write only the part between `<!-- ARTIFACT:START -->` and `<!-- ARTIFACT:END -->` to a separate file (the artifact host adds its own `<html>`/`<head>`/`<body>`).
   - Publish that file with `icon: "book"` and a one-sentence `description`.
4. Reply with:
   - the absolute file path, and the artifact link if one was published
   - the list of pages read (and any that failed)
   - any part where the docs were thin, so the user knows where the digest is limited
