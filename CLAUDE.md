# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Qué es

Web personal / CV online de José Luis Domínguez Rondán. Todo vive en un único archivo, `index.html` (CSS y JS en línea, sin dependencias externas ni paso de build). La misma página sirve como web y, mediante la hoja de impresión, como CV en PDF.

## Comandos

- **Ver la página:** abrir `index.html` directamente o vía Apache local en `http://localhost/miweb/` (el repo está dentro de `htdocs`). `?lang=es` / `?lang=en` fuerza el idioma.
- **Regenerar los CV en PDF** (Git Bash, requiere Chrome o Edge instalado):
  ```bash
  bash tools/build-cv.sh
  ```
  Imprime `index.html?lang=es|en` en headless y escribe `cv/CV-JoseLuisDominguezRondan-{ES,EN}.pdf`. Hay que volver a ejecutarlo y commitear los PDF **cada vez que cambie el contenido** de `index.html`, o el botón "Descargar CV" servirá un CV desactualizado.
- No hay tests, linter ni Node en este entorno.

## Arquitectura de `index.html`

**Textos e i18n (ES/EN).** Casi todo el texto visible NO está en el HTML: los elementos llevan atributos vacíos y se rellenan desde el diccionario `I18N` del `<script>` final:
- `data-i18n="clave"` → `textContent`
- `data-i18n-html="clave"` → `innerHTML` (descripciones de experiencia con `<p>`, `<ul>`, enlaces)
- `data-i18n-placeholder`, `data-i18n-aria` → atributos

Toda clave debe existir en `I18N.es` **y** `I18N.en`; al cambiar un texto, actualizar ambos idiomas. Lo que no se traduce (nombre, empresas, fechas, etiquetas de tecnologías, certificaciones) está escrito directamente en el HTML. Los huecos en la numeración de claves de experiencia (`xp1`, `xp2`, `xp3`, `xp5`…) son entradas eliminadas; no hace falta renumerar.

Prioridad del idioma: `?lang=` en la URL > `localStorage['miweb.lang']` > idioma del navegador. `applyLang()` además actualiza el enlace del CV (`#cv-btn`, PDF según idioma) y el `mailto` de `#contact-btn` (asunto traducido).

**Tema claro/oscuro.** Colores como variables CSS en `:root`, redefinidas en `:root[data-theme="dark"]`. El tema por defecto es claro (decisión explícita: no seguir `prefers-color-scheme`). Un `<script>` en `<head>` aplica `localStorage['miweb.theme']` antes del render para evitar parpadeo; el botón ☀️/🌙 lo alterna.

**Modo impresión = CV.** El bloque `@media print` + `@page` (A4, pie con nombre y nº de página) transforma la página: oculta barra superior, botones, fondos animados y pie; fuerza paleta clara aunque esté activo el modo oscuro; muestra los elementos `.print-only` (datos de contacto). Cualquier cambio de diseño en pantalla debe revisarse también en la vista de impresión / PDF generado.

**Responsive:** un único breakpoint en `max-width: 520px`. Animaciones desactivadas con `prefers-reduced-motion`.

## Contenido y datos

- `Profile.pdf` (exportación de LinkedIn, sin trackear) es la fuente de los datos del perfil. No debe commitearse ni publicarse.
- `img/yo.jpg` es la foto del avatar.
