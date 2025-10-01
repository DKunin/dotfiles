// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

const BoardMixApp = {
  browser: ({ urlString }) => ({
    name: "Google Chrome",
    // profile: "Profile 13", // use whatever profile created the application shortcut
    args: [
      `--app-id=jeleglcnfdjhgfelgbmeplgiegkbkbjp`, // my app ID for my Google Meet application shortcut
      `--app-launch-url-for-shortcuts-menu-item=${urlString}`,
      // notice I'm not passing urlString as an array entry, since Chrome Application Shortcuts don't like that
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
  rewrite: [
    {
      // Redirect all urls to use https
      match: finicky.matchHostnames(/.*\.ktalk.ru/),
      url: ({ url }) => {
        return "http://127.0.0.1:44258/ktalk/app/open-url?url=" + url;
      },
    },

    {
      match: /vk\.com\/away.php/,
      url: ({ url }) => {
        const match = url.search.match(/to=(.+)/);
        return !match ? url : decodeURIComponent(decodeURIComponent(match[1]));
      },
    },
    {
      match: () => true, // Execute rewrite on all incoming urls to make this example easier to understand
      url: ({ url }) => {
        const removeKeysStartingWith = ["utm_", "uta_"]; // Remove all query parameters beginning with these strings
        const removeKeys = ["fbclid", "gclid"]; // Remove all query parameters matching these keys

        const search = url.search
          .split("&")
          .map((parameter) => parameter.split("="))
          .filter(
            ([key]) =>
              !removeKeysStartingWith.some((startingWith) =>
                key.startsWith(startingWith)
              )
          )
          .filter(
            ([key]) => !removeKeys.some((removeKey) => key === removeKey)
          );

        return {
          ...url,
          search: search.map((parameter) => parameter.join("=")).join("&"),
        };
      },
    },
    {
      match: finicky.matchHostnames(["google.com"]),
      url: "https://duckduckgo.com",
    },
  ],
  handlers: [
    {
      match: [
        finicky.matchHostnames(/gitlab.senseai.pro/g),
        finicky.matchHostnames(/console.yandex.cloud/g),
        finicky.matchHostnames(/bot.senseai.pro/g),
      ],
      // Forward to Brave
      browser: "Brave Browser",
    },
    {
      match: [
        finicky.matchHostnames(/mt.avito.ru/g),
      ],
      // Forward to Chrome
      browser: "Google Chrome",
    },
  ],
  // handlers: [
  //   {
  //     match: [
  //       // finicky.matchDomains(/boardmix.com/g) // use helper function to match on domain only
  //     ],
  //     // browser: "/Applications/Chrome\\ Apps.localized/BoardMix.app"
  //     // browser: "Chrome"
  //     ...BoardMixApp,
  //   }
  // ]
};
