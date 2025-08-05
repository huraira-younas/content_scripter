import { useState } from 'react';
import store from '../../../../redux/store';
export function Dark(actionfunction) {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataThemeMode": "dark",
        "dataHeaderStyles": "dark",
        "dataMenuStyles": "dark",
    });
    localStorage.setItem("ynexdarktheme", "dark");
    localStorage.removeItem("ynexlighttheme");
    localStorage.removeItem("ynexMenu");
    localStorage.removeItem("ynexHeader");

}
export function Light(actionfunction) {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataThemeMode": "light",
        "dataHeaderStyles": "light",
        "darkBg": "",
        "bodyBg1": "",
        "bodyBg2": "",
        "inputBorder": "",
        "dataMenuStyles": theme.dataNavLayout == 'horizontal' ? 'light' : "dark"

    });
    localStorage.setItem("ynexlighttheme", "light");
    localStorage.removeItem("ynexdarktheme");
    localStorage.removeItem('darkBgRGB1');
    localStorage.removeItem('darkBgRGB2');
    localStorage.removeItem('darkBgRGB3');
    localStorage.removeItem('darkBgRGB4');
}
export function Ltr(actionfunction) {
    const theme = store.getState();
    actionfunction({ ...theme, dir: "ltr" });
    localStorage.setItem("ynexltr", "ltr");
    localStorage.removeItem("ynexrtl");
}
export function Rtl(actionfunction) {
    const theme = store.getState();
    actionfunction({ ...theme, dir: "rtl" });
    localStorage.setItem("ynexrtl", "rtl");
    localStorage.removeItem("ynexltr");
}
export const HorizontalClick = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavLayout": "horizontal",
        "dataMenuStyles": localStorage.ynexdarktheme ? 'dark' : localStorage.darkBgRGB1 ? 'dark' : localStorage.ynexMenu ? localStorage.ynexMenu : "light",
        "dataVerticalStyle": "",
        "dataNavStyle": localStorage.ynexnavstyles ? localStorage.ynexnavstyles : "menu-click"
    });
    localStorage.setItem("ynexlayout", "horizontal");
    localStorage.removeItem("ynexverticalstyles");
};
export const Vertical = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavLayout": "vertical",
        "dataMenuStyles": "dark",
        "dataVerticalStyle": "overlay",
        "toggled": ""
    });
    localStorage.setItem("ynexlayout", "vertical");
};

export const Menuclick = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavStyle": "menu-click",
        "dataVerticalStyle": "",
        "toggled": "menu-click-closed",
    });
    localStorage.setItem("ynexnavstyles", "menu-click");
    localStorage.removeItem("ynexverticalstyles");
};
export const MenuHover = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavStyle": "menu-hover",
        "dataVerticalStyle": "",
        "toggled": "menu-hover-closed",
        "horStyle": ""
    });
    localStorage.setItem("ynexnavstyles", "menu-hover");
    localStorage.removeItem("ynexverticalstyles");
};
export const IconClick = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavStyle": "icon-click",
        "dataVerticalStyle": "",
        "toggled": "icon-click-closed",
    });
    localStorage.setItem("ynexnavstyles", "icon-click");
    localStorage.removeItem("ynexverticalstyles");
};
export const IconHover = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavStyle": "icon-hover",
        "dataVerticalStyle": "",
        "toggled": "icon-hover-closed"
    });
    localStorage.setItem("ynexnavstyles", "icon-hover");
    localStorage.removeItem("ynexverticalstyles");
};
export const Fullwidth = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataWidth": "fullwidth",
    });
    localStorage.setItem("ynexfullwidth", "Fullwidth");
    localStorage.removeItem("ynexboxed");

};
export const Boxed = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataWidth": "boxed",
    });
    localStorage.setItem("ynexboxed", "Boxed");
    localStorage.removeItem("ynexfullwidth");
};
export const FixedMenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataMenuPosition": "fixed",
    });
    localStorage.setItem("ynexmenufixed", "MenuFixed");
    localStorage.removeItem("ynexmenuscrollable");
};
export const scrollMenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataMenuPosition": "scrollable",
    });
    localStorage.setItem("ynexmenuscrollable", "Menuscrolled");
    localStorage.removeItem("ynexmenufixed");
};
export const Headerpostionfixed = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataHeaderPosition": "fixed",
    });
    localStorage.setItem("ynexheaderfixed", 'FixedHeader');
    localStorage.removeItem("ynexheaderscrollable");
};
export const Headerpostionscroll = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataHeaderPosition": "scrollable",
    });
    localStorage.setItem("ynexheaderscrollable", "ScrollableHeader");
    localStorage.removeItem("ynexheaderfixed");
};
export const Regular = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataPageStyle": "regular"
    });
    localStorage.setItem("ynexregular", "Regular");
    localStorage.removeItem("ynexclassic");
    localStorage.removeItem("ynexmodern");
};
export const Classic = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataPageStyle": "classic",
    });
    localStorage.setItem("ynexclassic", "Classic");
    localStorage.removeItem("ynexregular");
    localStorage.removeItem("ynexmodern");
};
export const Modern = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataPageStyle": "modern",
    });
    localStorage.setItem("ynexmodern", "Modern");
    localStorage.removeItem("ynexregular");
    localStorage.removeItem("ynexclassic");
};
export function Enable(actionfunction) {
    const theme = store.getState();
    actionfunction({ ...theme, loader: "enable" });
    localStorage.setItem("ynexloaderenable", "enable");
    localStorage.setItem("ynexloaderdisable", "enable");
}
export function Disable(actionfunction) {
    const theme = store.getState();
    actionfunction({ ...theme, loader: "disable" });
    localStorage.setItem("ynexloaderdisable", "disable");
    localStorage.removeItem("ynexloaderenable");
}
export const Defaultmenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        // "dataVerticalStyle": "default",
        "dataVerticalStyle": "overlay",
        "dataNavLayout": "vertical",
        'toggled': ''
    });
    localStorage.removeItem("ynexnavstyles");
    localStorage.setItem("ynexverticalstyles", "default");

};
export const Closedmenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavLayout": "vertical",
        "dataVerticalStyle": "closed",
        "toggled": "close-menu-close"
    });
    localStorage.setItem("ynexverticalstyles", "closed");
    localStorage.removeItem("ynexnavstyles");

};

export const iconText = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavLayout": "vertical",
        "dataVerticalStyle": "icontext",
        "toggled": "icon-text-close"
    });
    localStorage.setItem("ynexverticalstyles", "icontext");
    localStorage.removeItem("ynexnavstyles");
};
export const iconOverayFn = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavLayout": "vertical",
        "dataVerticalStyle": "overlay",
        "toggled": "icon-overlay-close",
    });
    localStorage.setItem("ynexverticalstyles", "overlay");
    localStorage.removeItem("ynexnavstyles");
};
export const DetachedFn = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavLayout": "vertical",
        "dataVerticalStyle": "detached",
        "toggled": "detached-close",
    });
    localStorage.setItem("ynexverticalstyles", "detached");
    localStorage.removeItem("ynexnavstyles");
};

export const DoubletFn = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataNavLayout": "vertical",
        "dataVerticalStyle": "doublemenu",
        "toggled": "double-menu-open",
    });
    localStorage.setItem("ynexverticalstyles", "doublemenu");
    localStorage.removeItem("ynexnavstyles");

    setTimeout(() => {
        if (!document.querySelectorAll(".main-menu .slide.active")[0].querySelector('ul')) {
            const theme = store.getState();
            actionfunction(
                {
                    ...theme,
                    "toggled": "double-menu-close",
                }
            );
        }

    }, 100);
};
export const bgImage1 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bgImg": "bgimg1"
    });
    localStorage.setItem("bgimage1", "bgimg1");
    localStorage.removeItem("bgimage2");
    localStorage.removeItem("bgimage3");
    localStorage.removeItem("bgimage4");
    localStorage.removeItem("bgimage5");
};
export const bgImage2 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bgImg": "bgimg2"
    });
    localStorage.setItem("bgimage2", "bgimg2");
    localStorage.removeItem("bgimage1");
    localStorage.removeItem("bgimage3");
    localStorage.removeItem("bgimage4");
    localStorage.removeItem("bgimage5");
};
export const bgImage3 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bgImg": "bgimg3"
    });
    localStorage.setItem("bgimage3", "bgimg3");
    localStorage.removeItem("bgimage1");
    localStorage.removeItem("bgimage2");
    localStorage.removeItem("bgimage4");
    localStorage.removeItem("bgimage5");
};
export const bgImage4 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bgImg": "bgimg4"
    });
    localStorage.setItem("bgimage4", "bgimg4");
    localStorage.removeItem("bgimage1");
    localStorage.removeItem("bgimage2");
    localStorage.removeItem("bgimage3");
    localStorage.removeItem("bgimage5");
};
export const bgImage5 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bgImg": "bgimg5"
    });
    localStorage.setItem("bgimage5", "bgimg5");
    localStorage.removeItem("bgimage1");
    localStorage.removeItem("bgimage2");
    localStorage.removeItem("bgimage3");
    localStorage.removeItem("bgimage4");
};

export const colorMenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataMenuStyles": "color",
    });
    localStorage.setItem("ynexMenu", "color");
    localStorage.removeItem("gradient");
};

export const lightMenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataMenuStyles": "light",
    });
    localStorage.setItem("ynexMenu", "light");
    localStorage.removeItem("light");
};

export const darkMenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataMenuStyles": "dark",
    });
    localStorage.setItem("ynexMenu", "dark");
    localStorage.removeItem("light");
};

export const gradientMenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataMenuStyles": "gradient",
    });
    localStorage.setItem("ynexMenu", "gradient");
    localStorage.removeItem("color");
};
export const transparentMenu = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataMenuStyles": "transparent",
    });
    localStorage.setItem("ynexMenu", "transparent");
    localStorage.removeItem("gradient");
};

export const lightHeader = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataHeaderStyles": "light",
    });
    localStorage.setItem("ynexHeader", "light");
    localStorage.removeItem("dark");
};
export const darkHeader = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataHeaderStyles": "dark",
    });
    localStorage.setItem("ynexHeader", "dark");
    localStorage.removeItem("light");
};
export const colorHeader = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataHeaderStyles": "color",
    });
    localStorage.setItem("ynexHeader", "color");
    localStorage.removeItem("dark");
};
export const gradientHeader = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataHeaderStyles": "gradient",

    });
    localStorage.setItem("ynexHeader", "gradient");
    localStorage.removeItem("transparent");
};
export const transparentHeader = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "dataHeaderStyles": "transparent",
    });
    localStorage.removeItem("gradient");
    localStorage.setItem("ynexHeader", "transparent");
};

export const primaryColor1 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "colorPrimaryRgb": "58, 88, 146",
    });
    localStorage.setItem("primaryRGB", "58, 88, 146");

};
export const primaryColor2 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "colorPrimaryRgb": "92, 144, 163",
    });
    localStorage.setItem("primaryRGB", "92, 144, 163");
};
export const primaryColor3 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "colorPrimaryRgb": "161, 90, 223",
    });
    localStorage.setItem("primaryRGB", "161, 90, 223");
};
export const primaryColor4 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "colorPrimaryRgb": "78, 172, 76",
    });
    localStorage.setItem("primaryRGB", "78, 172, 76");
};
export const primaryColor5 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "colorPrimaryRgb": "223, 90, 90",
    });
    localStorage.setItem("primaryRGB", "223, 90, 90");
};

export const backgroundColor1 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bodyBg1": "20, 30, 96",
        "bodyBg2": "25, 38, 101",
        "darkBg": "25, 38, 101",
        "inputBorder": "255, 255, 255, 0.1",
        "dataThemeMode": "dark",
        "dataMenuStyles": "dark",
        "dataHeaderStyles": "dark"
    });
    localStorage.setItem('darkBgRGB1', "20, 30, 96");
    localStorage.setItem('darkBgRGB2', "25, 38, 101");
    localStorage.setItem('darkBgRGB3', "25, 38, 101");
    localStorage.setItem('darkBgRGB4', "255, 255, 255, 0.1");

};
export const backgroundColor2 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bodyBg1": "8, 78, 115",
        "bodyBg2": "13, 86, 120",
        "darkBg": "13, 86, 120",
        "inputBorder": "255, 255, 255, 0.1",
        "dataThemeMode": "dark",
        "dataMenuStyles": "dark",
        "dataHeaderStyles": "dark"
    });
    localStorage.setItem('darkBgRGB1', "8, 78, 115");
    localStorage.setItem('darkBgRGB2', "13, 86, 120");
    localStorage.setItem('darkBgRGB3', "13, 86, 120",);
    localStorage.setItem('darkBgRGB4', "255, 255, 255, 0.1");
};
export const backgroundColor3 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bodyBg1": "90, 37, 135",
        "bodyBg2": "95, 45, 140",
        "darkBg": "95, 45, 140",
        "inputBorder": "255, 255, 255, 0.1",
        "dataThemeMode": "dark",
        "dataMenuStyles": "dark",
        "dataHeaderStyles": "dark"
    });
    localStorage.setItem('darkBgRGB1', "90, 37, 135");
    localStorage.setItem('darkBgRGB2', "95, 45, 140");
    localStorage.setItem('darkBgRGB3', "95, 45, 140",);
    localStorage.setItem('darkBgRGB4', "255, 255, 255, 0.1");
};
export const backgroundColor4 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bodyBg1": "24, 101, 51",
        "bodyBg2": "29, 109, 56",
        "darkBg": "29, 109, 56",
        "inputBorder": "255, 255, 255, 0.1",
        "dataThemeMode": "dark",
        "dataMenuStyles": "dark",
        "dataHeaderStyles": "dark"
    });
    localStorage.setItem('darkBgRGB1', "24, 101, 51");
    localStorage.setItem('darkBgRGB2', "29, 109, 56");
    localStorage.setItem('darkBgRGB3', "29, 109, 56");
    localStorage.setItem('darkBgRGB4', "255, 255, 255, 0.1");
};
export const backgroundColor5 = (actionfunction) => {
    const theme = store.getState();
    actionfunction({
        ...theme,
        "bodyBg1": "120, 66, 20",
        "bodyBg2": "125, 74,25",
        "darkBg": "125, 74, 25",
        "inputBorder": "255, 255, 255, 0.1",
        "dataThemeMode": "dark",
        "dataMenuStyles": "dark",
        "dataHeaderStyles": "dark"
    });
    localStorage.setItem('darkBgRGB1', "120, 66, 20");
    localStorage.setItem('darkBgRGB2', "125, 74,25");
    localStorage.setItem('darkBgRGB3', "125, 74,25");
    localStorage.setItem('darkBgRGB4', "255, 255, 255, 0.1");
};

const ColorPicker = (props) => {
    return (
        <div className="color-picker-input">
            <input type="color" {...props} />
        </div>
    );
};

function hexToRgb(hex) {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}
const Themeprimarycolor = ({ actionfunction }) => {
    const theme = store.getState();
    const [state, updateState] = useState("#FFFFFF");

    const handleInput = (e) => {
        const rgb = hexToRgb(e.target.value);

        if (rgb !== null) {
            const { r, g, b } = rgb;
            updateState(e.target.value);
            actionfunction({
                ...theme,
                "colorPrimaryRgb": `${r} , ${g} , ${b}`,
            });
            localStorage.setItem("dynamiccolor", `${r}, ${g}, ${b}`);
        }
    };

    return (
        <div className="Themeprimarycolor theme-container-primary pickr-container-primary">
            <ColorPicker onChange={handleInput} value={state} />
        </div>
    );
};

export default Themeprimarycolor;

//themeBackground
export const Themebackgroundcolor = ({ actionfunction }) => {
    const theme = store.getState();
    const [state, updateState] = useState("#FFFFFF");
    const handleInput = (e) => {
        const { r, g, b } = hexToRgb(e.target.value);
        updateState(e.target.value);
        actionfunction({
            ...theme,
            "bodyBg1": `${r}, ${g}, ${b}`,
            "bodyBg2": `${r + 19}, ${g + 19}, ${b + 19}`,
            "darkBg": `${r + 19}, ${g + 19}, ${b + 19}`,
            "inputBorder": "255, 255, 255, 0.1",
            "dataThemeMode": "dark",
            "dataHeaderStyles": "dark",
            "dataMenuStyles": "dark"
        });
        localStorage.setItem("darkBgRGB1", `${r}, ${g}, ${b}`);
        localStorage.setItem("darkBgRGB2", `${r + 19}, ${g + 19}, ${b + 19}`);
        localStorage.setItem("darkBgRGB3", `${r + 19}, ${g + 19}, ${b + 19}`);
        localStorage.setItem("darkBgRGB4", "255, 255, 255, 0.1");
        localStorage.removeItem("ynexMenu");
        localStorage.removeItem("ynexHeader");

    };
    return (
        <div className="Themebackgroundcolor">
            <ColorPicker onChange={handleInput} value={state} />
        </div>
    );
};

export const Reset = (actionfunction) => {
    const theme = store.getState();
    Vertical(actionfunction);
    actionfunction({
        ...theme,
        lang: "en",
        dir: "ltr",
        dataThemeMode: "light",
        dataMenuStyles: "dark",
        dataNavLayout: "vertical",
        dataHeaderStyles: "light",
        dataVerticalStyle: "overlay",
        StylebodyBg: "107 64 64",
        StyleDarkBg: "93 50 50",
        toggled: "",
        dataNavStyle: "",
        horStyle: "",
        dataPageStyle: "regular",
        dataWidth: "fullwidth",
        dataMenuPosition: "fixed",
        dataHeaderPosition: "fixed",
        loader: "disable",
        iconOverlay: "",
        colorPrimaryRgb: "",
        bodyBg1: "",
        bodyBg2: "",
        darkBg: "",
        inputBorder: "",
        bgImg: "",
        iconText: "",
        body: {
            class: ""
        }
    });
    localStorage.clear();
};
export const Reset1 = (actionfunction) => {
    const theme = store.getState();
    Vertical(actionfunction);
    actionfunction({
        ...theme,
        lang: "en",
        dir: "ltr",
        dataThemeMode: "light",
        dataMenuStyles: "dark",
        dataNavLayout: "horizontal",
        dataHeaderStyles: "",
        dataVerticalStyle: "overlay",
        StylebodyBg: "107 64 64",
        StyleDarkBg: "93 50 50",
        toggled: "",
        dataNavStyle: "menu-click",
        dataMenuPosition: "fixed",
        iconOverlay: "",
        colorPrimaryRgb: "",
        bgImg: "",
        iconText: "",
        body: {
            class: ""
        }
    });
    localStorage.clear();
};
export const LocalStorageBackup = (actionfunction) => {

    (localStorage.ynexltr) ? Ltr(actionfunction) : "";
    (localStorage.ynexrtl) ? Rtl(actionfunction) : "";
    (localStorage.ynexdarktheme) ? Dark(actionfunction) : "";
    (localStorage.ynexlighttheme) ? Light(actionfunction) : "";
    (localStorage.ynexregular) ? Regular(actionfunction) : "";
    (localStorage.ynexclassic) ? Classic(actionfunction) : "";
    (localStorage.ynexmodern) ? Modern(actionfunction) : "";
    (localStorage.ynexfullwidth) ? Fullwidth(actionfunction) : "";
    (localStorage.ynexboxed) ? Boxed(actionfunction) : "";
    (localStorage.ynexmenufixed) ? FixedMenu(actionfunction) : "";
    (localStorage.ynexmenuscrollable) ? scrollMenu(actionfunction) : "";
    (localStorage.ynexheaderfixed) ? Headerpostionfixed(actionfunction) : "";
    (localStorage.ynexheaderscrollable) ? Headerpostionscroll(actionfunction) : "";

    (localStorage.ynexloaderenable) ? Enable(actionfunction) : "";
    (localStorage.ynexloaderdisable) ? Disable(actionfunction) : "";

    (localStorage.ynexnavstyles === "menu-click") ? Menuclick(actionfunction) : '';
    (localStorage.ynexnavstyles === "menu-hover") ? MenuHover(actionfunction) : '';
    (localStorage.ynexnavstyles === "icon-click") ? IconClick(actionfunction) : '';
    (localStorage.ynexnavstyles === "icon-hover") ? IconHover(actionfunction) : '';

    (localStorage.bgimage1) ? bgImage1(actionfunction) : '';
    (localStorage.bgimage2) ? bgImage2(actionfunction) : '';
    (localStorage.bgimage3) ? bgImage3(actionfunction) : '';
    (localStorage.bgimage4) ? bgImage4(actionfunction) : '';
    (localStorage.bgimage5) ? bgImage5(actionfunction) : '';
    (localStorage.ynexlayout == 'horizontal') && HorizontalClick(actionfunction);
    (localStorage.ynexlayout == 'vertical') && Vertical(actionfunction);
    //primitive 
    if (
        localStorage.getItem("ynexltr") == null ||
        localStorage.getItem("ynexltr") == "ltr"
    )

        // Theme Primary: Colors: Start
        switch (localStorage.primaryRGB) {
            case '58, 88, 146':
                primaryColor1(actionfunction);

                break;
            case '92, 144, 163':
                primaryColor2(actionfunction);

                break;
            case "161, 90, 223":
                primaryColor3(actionfunction);

                break;
            case "78, 172, 76":
                primaryColor4(actionfunction);

                break;
            case "223, 90, 90":
                primaryColor5(actionfunction);

                break;
            default:
                break;
        }
    // Theme Primary: Colors: End

    switch (localStorage.darkBgRGB1) {
        case '20, 30, 96':
            backgroundColor1(actionfunction);

            break;
        case '8, 78, 115':
            backgroundColor2(actionfunction);

            break;
        case '90, 37, 135':
            backgroundColor3(actionfunction);

            break;
        case '24, 101, 51':
            backgroundColor4(actionfunction);

            break;
        case '120, 66, 20':
            backgroundColor5(actionfunction);

            break;
        default:
            break;
    }

    //layout
    if (localStorage.ynexverticalstyles) {
        const verticalStyles = localStorage.getItem("ynexverticalstyles");

        switch (verticalStyles) {
            case "default":
                Defaultmenu(actionfunction);
                break;
            case "closed":
                Closedmenu(actionfunction);
                break;
            case "icontext":
                iconText(actionfunction);
                break;
            case "overlay":
                iconOverayFn(actionfunction);
                break;
            case "detached":
                DetachedFn(actionfunction);
                break;
            case "doublemenu":
                DoubletFn(actionfunction);
                break;
        }
    }

    //Theme Primary:
    if (localStorage.dynamiccolor) {
        const theme = store.getState();
        actionfunction({
            ...theme,
            "colorPrimaryRgb": localStorage.dynamiccolor,
            "colorPrimary": localStorage.dynamiccolor
        });
    }
    //Theme BAckground:
    //Theme BAckground:
    if (localStorage.darkBgRGB1) {
        const theme = store.getState();
        actionfunction({
            ...theme,
            "bodyBg1": localStorage.darkBgRGB1,
            "bodyBg2": localStorage.darkBgRGB2,
            "darkBg": localStorage.darkBgRGB3,
            "inputBorder": localStorage.darkBgRGB4,
            "dataThemeMode": "dark",
            "dataHeaderStyles": "dark",
            "dataMenuStyles": "dark",
        });
        // Dark(actionfunction);
    }
    switch (localStorage.ynexMenu) {
        case 'light':
            lightMenu(actionfunction);
            break;
        case 'dark':
            darkMenu(actionfunction);

            break;
        case 'color':
            colorMenu(actionfunction);

            break;
        case 'gradient':
            gradientMenu(actionfunction);

            break;
        case 'transparent':
            transparentMenu(actionfunction);

            break;
        default:
            break;
    }
    // ThemeColor Header Colors: start
    switch (localStorage.ynexHeader) {
        case 'light':
            lightHeader(actionfunction);

            break;
        case 'dark':
            darkHeader(actionfunction);

            break;
        case 'color':
            colorHeader(actionfunction);

            break;
        case 'gradient':
            gradientHeader(actionfunction);

            break;
        case 'transparent':
            transparentHeader(actionfunction);

            break;
        default:
            break;
    }
};
