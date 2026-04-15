// Learn more: https://github.com/johnste/finicky/wiki/Configuration

const BoardMixApp = {
  browser: ({ urlString }) => ({
    name: "Google Chrome",
    // profile: "Profile 13",
    args: [
      "--app-id=jeleglcnfdjhgfelgbmeplgiegkbkbjp",
      `--app-launch-url-for-shortcuts-menu-item=${urlString}`,
    ],
  }),
};

export default {
  defaultBrowser: "Google Chrome",
  options: {
    hideIcon: false,
    checkForUpdate: true,
    logRequests: true,
  },

  // ---------- REWRITE ----------
  rewrite: [
    // 1) mattermost://...  →  https://...
    {
      match: ({ url }) => url && url.protocol === "mattermost:",
      url: ({ url }) => {
        const host = url.host || url.hostname || "";
        const path = url.pathname || "";
        const search = url.search
          ? (url.search.startsWith("?") ? url.search : `?${url.search}`)
          : "";
        const hash = url.hash
          ? (url.hash.startsWith("#") ? url.hash : `#${url.hash}`)
          : "";

        const httpsUrl = `https://${host}${path}${search}${hash}`;
        // Немного логирования, чтобы видеть факт переписывания
        try { console.log(`[finicky] mattermost→https: ${httpsUrl}`); } catch (e) {}
        return httpsUrl;
      },
    },

    // 2) VK away cleanup
    {
      match: ({ url }) => /vk\.com\/away\.php/i.test(url.host + url.pathname),
      url: ({ url }) => {
        const m = (url.search || "").match(/(?:\?|&)to=([^&]+)/);
        return !m ? url : decodeURIComponent(decodeURIComponent(m[1]));
      },
    },

    // 3) Удаляем трекинг-параметры (для всех URL)
    {
      match: () => true,
      url: ({ url }) => {
        const removeKeysStartingWith = ["utm_", "uta_"];
        const removeKeys = ["fbclid", "gclid"];

        const raw = (url.search || "").replace(/^\?/, "");
        if (!raw) return url;

        const kept = raw
          .split("&")
          .filter(Boolean)
          .map((p) => p.split("="))
          .filter(([k]) => k && !removeKeysStartingWith.some((pref) => k.startsWith(pref)))
          .filter(([k]) => k && !removeKeys.includes(k))
          .map((arr) => arr.join("="))
          .join("&");

        return { ...url, search: kept };
      },
    },

    // 4) example redirect (google → duckduckgo)
    {
      match: ({ url }) => (url.host || "").toLowerCase() === "google.com",
      url: "https://duckduckgo.com",
    },
  ],

  // ---------- HANDLERS ----------
  handlers: [
    // mt.avito.ru → Chrome
    {
      match: ({ url }) => /\.?mt\.avito\.ru$/i.test(url.host || ""),
      browser: "Google Chrome",
    },

    // Эти — в Brave
    {
      match: ({ url }) =>
        /(^|\.)gitlab\.senseai\.pro$/i.test(url.host || "") ||
        /(^|\.)console\.yandex\.cloud$/i.test(url.host || "") ||
        /(^|\.)bot\.senseai\.pro$/i.test(url.host || ""),
      browser: "Brave Browser",
    },

    // Пример открытия Chrome App (оставлено как шаблон, закомментировано)
    // {
    //   match: ({ url }) => /(^|\.)boardmix\.com$/i.test(url.host || ""),
    //   ...BoardMixApp,
    // },
  ],
};
