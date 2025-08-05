export const MENUITEMS = [
  {
    menutitle: "USERS",
    Items: [
      {
        icon: <i className="side-menu__icon bx bx-user"></i>,
        type: "sub",
        Name: "",
        active: false,
        selected: false,
        title: "Users",
        badge: "",
        class: "badge bg-warning-transparent ms-2",
        children: [
          {
            path: `${import.meta.env.BASE_URL}users/list`,
            type: "link",
            active: false,
            selected: false,
            title: "Manage users",
          },
        ],
      },
    ],
  },
  {
    menutitle: "SETTINGS",
    Items: [
      {
        icon: <i className="side-menu__icon bx bx-cog"></i>,
        type: "sub",
        Name: "",
        active: false,
        selected: false,
        title: "Settings",
        badge: "",
        class: "badge bg-warning-transparent ms-2",
        children: [
          {
            path: `${import.meta.env.BASE_URL}settings/privacy-policy`,
            type: "link",
            active: false,
            selected: false,
            title: "Privacy Policy",
          },
          {
            path: `${import.meta.env.BASE_URL}settings/terms-&-services`,
            type: "link",
            active: false,
            selected: false,
            title: "Terms & Services",
          },
          {
            path: `${import.meta.env.BASE_URL}settings/faq`,
            type: "link",
            active: false,
            selected: false,
            title: "Faq",
          },
          {
            path: `${import.meta.env.BASE_URL}settings/contact-us`,
            type: "link",
            active: false,
            selected: false,
            title: "Contact us",
          },
        ],
      },
    ],
  },
  {
    menutitle: "ONBOARDING",
    Items: [
      {
        icon: <i className="side-menu__icon bx bx-file-blank"></i>,
        type: "sub",
        Name: "",
        active: false,
        selected: false,
        title: "On Boarding",
        badge: "",
        class: "badge bg-warning-transparent ms-2",
        children: [
          {
            path: `${import.meta.env.BASE_URL}on-boarding/create`,
            type: "link",
            active: false,
            selected: false,
            title: "Create Onboarding",
          },
          {
            path: `${import.meta.env.BASE_URL}on-boarding/manage`,
            type: "link",
            active: false,
            selected: false,
            title: "Manage Onboarding",
          },
        ],
      },
    ],
  },
  {
    menutitle: "PROMPT",
    Items: [
      {
        path: `${import.meta.env.BASE_URL}prompt`,
        icon: <i className="bx bx-gift side-menu__icon"></i>,
        title: "Prompt",
        type: "link",
        badge: "",
        class: "badge bg-danger-transparent ms-2",
        selected: false,
        active: false,
      },
    ],
  },
  {
    menutitle: "ASSISTANT",
    Items: [
      {
        icon: <i className="side-menu__icon bx bx-task"></i>,
        type: "sub",
        Name: "",
        active: false,
        selected: false,
        title: "Assistants",
        badge: "",
        class: "badge bg-warning-transparent ms-2",
        children: [
          {
            path: `${import.meta.env.BASE_URL}assistant/create`,
            type: "link",
            active: false,
            selected: false,
            title: "Create Assistant",
          },
          {
            path: `${import.meta.env.BASE_URL}assistant/manage`,
            type: "link",
            active: false,
            selected: false,
            title: "Manage Assistant",
          },
        ],
      },
    ],
  },
  {
    menutitle: "MEMBERSHIP",
    Items: [
      {
        icon: <i className="side-menu__icon bx bx-medal"></i>,
        type: "sub",
        Name: "",
        active: false,
        selected: false,
        title: "Memberships",
        badge: "",
        class: "badge bg-warning-transparent ms-2",
        children: [
          {
            path: `${import.meta.env.BASE_URL}memberships/plans`,
            type: "link",
            active: false,
            selected: false,
            title: "Manage Plans",
          },
          {
            path: `${import.meta.env.BASE_URL}memberships/create`,
            type: "link",
            active: false,
            selected: false,
            title: "Create Plan",
          },
          {
            path: `${import.meta.env.BASE_URL}memberships/duration`,
            type: "link",
            active: false,
            selected: false,
            title: "Manage Duration",
          },
        ],
      },
    ],
  },
];
