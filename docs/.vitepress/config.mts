import { defineConfig } from "vitepress";
import llmstxt from "vitepress-plugin-llms";

// Site configuration
export const SITE_URL = "https://muhammad-fiaz.github.io/tint.zig";
export const SITE_NAME = "tint.zig";
export const SITE_DESCRIPTION =
  "A comprehensive, explicit terminal color and text styling library for Zig, supporting ANSI, bright ANSI, 256-color, RGB, HEX, HSL, HSV, CMYK, LAB, XYZ, palettes, themes, composable styles, and color manipulation.";

// Google Analytics and Google Tag Manager IDs
export const GA_ID = "G-6BVYCRK57P";
export const GTM_ID = "GTM-P4M9T8ZR";

// Google AdSense Client ID
export const ADSENSE_CLIENT_ID = "ca-pub-2040560600290490";

// SEO Keywords
export const KEYWORDS =
  "zig, terminal, color, ansi, style, rgb, hex, truecolor, 256-color, palette, theme, styling, escape, sgr, text, formatting, cli, cmyk, lab, xyz, hsl, hsv, color-manipulation";

export default defineConfig({
  lang: "en-US",
  title: SITE_NAME,
  description: SITE_DESCRIPTION,
  base: "/tint.zig/",
  lastUpdated: true,
  cleanUrls: false,

  sitemap: {
    hostname: SITE_URL,
  },

  vite: {
    plugins: [llmstxt()],
  },

  head: [
    // Primary Meta Tags
    ["meta", { name: "title", content: SITE_NAME }],
    ["meta", { name: "description", content: SITE_DESCRIPTION }],
    ["meta", { name: "keywords", content: KEYWORDS }],
    ["meta", { name: "author", content: "Muhammad Fiaz" }],
    ["meta", { name: "robots", content: "index, follow" }],
    ["meta", { name: "language", content: "English" }],
    ["meta", { name: "revisit-after", content: "7 days" }],
    ["meta", { name: "generator", content: "VitePress" }],

    // Open Graph
    ["meta", { property: "og:type", content: "website" }],
    ["meta", { property: "og:url", content: SITE_URL }],
    ["meta", { property: "og:title", content: SITE_NAME }],
    ["meta", { property: "og:description", content: SITE_DESCRIPTION }],
    [
      "meta",
      {
        property: "og:image",
        content: `${SITE_URL}/android-chrome-512x512.png`,
      },
    ],
    ["meta", { property: "og:image:width", content: "512" }],
    ["meta", { property: "og:image:height", content: "512" }],
    [
      "meta",
      {
        property: "og:image:alt",
        content: "tint.zig - Terminal color and styling library for Zig",
      },
    ],
    [
      "meta",
      {
        property: "og:image:secure_url",
        content: `${SITE_URL}/android-chrome-512x512.png`,
      },
    ],
    ["meta", { property: "og:site_name", content: SITE_NAME }],
    ["meta", { property: "og:locale", content: "en_US" }],

    // Twitter Card
    ["meta", { name: "twitter:card", content: "summary_large_image" }],
    ["meta", { name: "twitter:url", content: SITE_URL }],
    ["meta", { name: "twitter:title", content: SITE_NAME }],
    ["meta", { name: "twitter:description", content: SITE_DESCRIPTION }],
    [
      "meta",
      {
        name: "twitter:image",
        content: `${SITE_URL}/android-chrome-512x512.png`,
      },
    ],
    [
      "meta",
      {
        name: "twitter:image:alt",
        content: "tint.zig - Terminal color and styling library for Zig",
      },
    ],
    ["meta", { name: "twitter:site", content: "@muhammadfiaz_" }],
    ["meta", { name: "twitter:creator", content: "@muhammadfiaz_" }],

    // Canonical URL
    ["link", { rel: "canonical", href: SITE_URL }],

    // Favicons
    ["link", { rel: "icon", href: "/tint.zig/favicon.ico" }],
    [
      "link",
      {
        rel: "icon",
        type: "image/png",
        sizes: "16x16",
        href: "/tint.zig/favicon-16x16.png",
      },
    ],
    [
      "link",
      {
        rel: "icon",
        type: "image/png",
        sizes: "32x32",
        href: "/tint.zig/favicon-32x32.png",
      },
    ],
    [
      "link",
      {
        rel: "apple-touch-icon",
        sizes: "180x180",
        href: "/tint.zig/apple-touch-icon.png",
      },
    ],
    [
      "link",
      {
        rel: "icon",
        type: "image/png",
        sizes: "192x192",
        href: "/tint.zig/android-chrome-192x192.png",
      },
    ],
    [
      "link",
      {
        rel: "icon",
        type: "image/png",
        sizes: "512x512",
        href: "/tint.zig/android-chrome-512x512.png",
      },
    ],
    ["link", { rel: "manifest", href: "/tint.zig/site.webmanifest" }],

    // Theme color
    ["meta", { name: "theme-color", content: "#7C3AED" }],
    ["meta", { name: "msapplication-TileColor", content: "#7C3AED" }],

    // Google Analytics
    [
      "script",
      {
        async: "",
        src: `https://www.googletagmanager.com/gtag/js?id=${GA_ID}`,
      },
    ],
    [
      "script",
      {},
      `window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
gtag('config', '${GA_ID}');`,
    ],

    // Google Tag Manager
    ...(GTM_ID
      ? ([
          [
            "script",
            {},
            `(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s), dl=l!='dataLayer'?'&l='+l:''; j.async=true; j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl; f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','${GTM_ID}');`,
          ],
          [
            "noscript",
            {},
            `<iframe src="https://www.googletagmanager.com/ns.html?id=${GTM_ID}" height="0" width="0" style="display:none;visibility:hidden"></iframe>`,
          ],
        ] as [string, Record<string, string>, string][])
      : []),

    // Google AdSense
    [
      "script",
      {
        async: "",
        src: `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${ADSENSE_CLIENT_ID}`,
        crossorigin: "anonymous",
      },
    ],
  ],

  ignoreDeadLinks: [/.*\.zig$/],

  transformPageData(pageData: any) {
    const pageTitle = pageData.title || SITE_NAME;
    const pageDescription = pageData.description || SITE_DESCRIPTION;
    const normalizedPath = pageData.relativePath
      .replace(/\.md$/, "")
      .replace(/(^|\/)index$/, "$1")
      .replace(/\/$/, "");
    const canonicalUrl =
      normalizedPath.length > 0
        ? `${SITE_URL}/${normalizedPath}`
        : SITE_URL;

    pageData.frontmatter.head ??= [];
    pageData.frontmatter.head.push(
      ["link", { rel: "canonical", href: canonicalUrl }],
      [
        "meta",
        {
          property: "og:title",
          content: `${pageTitle} | ${SITE_NAME}`,
        },
      ],
      ["meta", { property: "og:url", content: canonicalUrl }],
    );

    if (pageData.frontmatter.description) {
      pageData.frontmatter.head.push(
        [
          "meta",
          {
            property: "og:description",
            content: pageData.frontmatter.description,
          },
        ],
        [
          "meta",
          { name: "description", content: pageData.frontmatter.description },
        ],
      );
    }

    const isHome = pageData.relativePath === "index.md";
    const lastUpdated = pageData.lastUpdated
      ? new Date(pageData.lastUpdated).toISOString()
      : new Date().toISOString();

    const graph: any[] = [];

    if (isHome) {
      graph.push({
        "@type": "WebSite",
        name: SITE_NAME,
        url: SITE_URL,
        description: SITE_DESCRIPTION,
        author: {
          "@type": "Person",
          name: "Muhammad Fiaz",
          url: "https://github.com/muhammad-fiaz",
        },
      });
    }

    const authorSchema = {
      "@type": "Person",
      name: "Muhammad Fiaz",
      url: "https://muhammadfiaz.com",
      sameAs: [
        "https://github.com/muhammad-fiaz",
        "https://www.linkedin.com/in/muhammad-fiaz-",
        "https://x.com/muhammadfiaz_",
      ],
    };

    const primarySchema: Record<string, any> = {
      "@type": isHome ? "SoftwareApplication" : "TechArticle",
      name: isHome ? SITE_NAME : pageTitle,
      description: pageDescription,
      url: canonicalUrl,
      image: `${SITE_URL}/android-chrome-512x512.png`,
      author: authorSchema,
      publisher: {
        "@type": "Organization",
        name: "tint.zig",
        url: SITE_URL,
        logo: {
          "@type": "ImageObject",
          url: `${SITE_URL}/logo.png`,
        },
      },
    };

    if (isHome) {
      Object.assign(primarySchema, {
        applicationCategory: "DeveloperApplication",
        operatingSystem: "Cross-platform",
        programmingLanguage: "Zig",
        offers: {
          "@type": "Offer",
          price: "0",
          priceCurrency: "USD",
        },
        downloadUrl: "https://github.com/muhammad-fiaz/tint.zig",
        license: "https://opensource.org/licenses/MIT",
        featureList: [
          "ANSI 4-bit and bright colors",
          "ANSI 256-color support",
          "RGB/TrueColor 24-bit color",
          "HEX color from integer",
          "HSL and HSV color space",
          "CMYK color conversion",
          "CIE XYZ and CIE Lab color spaces",
          "140+ CSS/X11 named colors",
          "Composable styles",
          "16 built-in themes",
          "Color manipulation (lighten, darken, saturate, desaturate, invert, grayscale, mix)",
          "Color harmony (complementary, analogous, triadic, split-complementary, tetradic)",
          "Color distance and contrast ratio",
          "Color temperature (Kelvin to RGB)",
           "Multi-stop palette gradients and rainbow hue gradients",
          "Zero dependencies",
          "Cross-platform (Windows, Linux, macOS)",
        ],
      });
    } else {
      const pathParts = pageData.relativePath.split("/");
      const section =
        pathParts.length > 1
          ? pathParts[0].charAt(0).toUpperCase() + pathParts[0].slice(1)
          : "Documentation";

      Object.assign(primarySchema, {
        headline: pageTitle,
        articleSection: section,
        mainEntityOfPage: {
          "@type": "WebPage",
          "@id": canonicalUrl,
        },
        datePublished: "2026-01-01T00:00:00Z",
        dateModified: lastUpdated,
      });
    }
    graph.push(primarySchema);

    const breadcrumbs: any[] = [
      {
        "@type": "ListItem",
        position: 1,
        name: "Home",
        item: SITE_URL,
      },
    ];

    if (!isHome) {
      const pathParts = pageData.relativePath.replace(/\.md$/, "").split("/");
      let currentPath = SITE_URL;

      pathParts.forEach((part: string, index: number) => {
        currentPath += `/${part}`;
        const name = part
          .split("-")
          .map((s: string) => s.charAt(0).toUpperCase() + s.slice(1))
          .join(" ");

        breadcrumbs.push({
          "@type": "ListItem",
          position: index + 2,
          name: name,
          item:
            index === pathParts.length - 1 ? canonicalUrl : currentPath,
        });
      });
    }

    graph.push({
      "@type": "BreadcrumbList",
      itemListElement: breadcrumbs,
    });

    pageData.frontmatter.head.push([
      "script",
      { type: "application/ld+json" },
      JSON.stringify({
        "@context": "https://schema.org",
        "@graph": graph,
      }),
    ]);
  },

  themeConfig: {
    logo: "/logo.png",
    siteTitle: "tint.zig",

    nav: [
      { text: "Home", link: "/" },
      { text: "Guide", link: "/guide/getting-started" },
      { text: "API", link: "/api/" },
      { text: "Examples", link: "/examples/" },
      {
        text: "Releases",
        link: "https://github.com/muhammad-fiaz/tint.zig/releases",
      },
      {
        text: "Support",
        items: [
          {
            text: "Sponsor",
            link: "https://github.com/sponsors/muhammad-fiaz",
          },
          { text: "Donate", link: "https://pay.muhammadfiaz.com" },
        ],
      },
      { text: "GitHub", link: "https://github.com/muhammad-fiaz/tint.zig" },
    ],

    sidebar: [
      {
        text: "Guide",
        items: [
          { text: "Getting Started", link: "/guide/getting-started" },
          { text: "Installation", link: "/guide/installation" },
          { text: "Colors", link: "/guide/colors" },
          { text: "Styles", link: "/guide/styles" },
          { text: "Palettes", link: "/guide/palettes" },
          { text: "Themes", link: "/guide/themes" },
        ],
      },
      {
        text: "API Reference",
        items: [
          { text: "Overview", link: "/api/" },
          { text: "Color", link: "/api/color" },
          { text: "Style", link: "/api/style" },
          { text: "Palette", link: "/api/palette" },
          { text: "Theme", link: "/api/theme" },
        ],
      },
      {
        text: "Examples",
        items: [
          { text: "Overview", link: "/examples/" },
          { text: "Basic", link: "/examples/basic" },
          { text: "Complete Demo", link: "/examples/complete" },
          { text: "CMYK", link: "/examples/cmyk" },
          { text: "Color Temperature", link: "/examples/color-temperature" },
          { text: "Color Manipulation", link: "/examples/color-manipulation" },
          { text: "Color Harmony", link: "/examples/color-harmony" },
          { text: "Color Analysis", link: "/examples/color-analysis" },
          { text: "Presets", link: "/examples/presets" },
          { text: "Themes Extended", link: "/examples/themes-extended" },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/muhammad-fiaz/tint.zig" },
    ],

    footer: {
      message: "Released under the MIT License.",
      copyright: "Copyright © 2026 Muhammad Fiaz",
    },

    search: {
      provider: "local",
    },

    editLink: {
      pattern:
        "https://github.com/muhammad-fiaz/tint.zig/edit/main/docs/:path",
      text: "Edit this page on GitHub",
    },

    lastUpdated: {
      text: "Last updated",
      formatOptions: {
        dateStyle: "medium",
        timeStyle: "short",
      },
    },
  },
});
