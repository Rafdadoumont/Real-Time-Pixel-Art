// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

function mapColor(value) {
    return (value / 3) * 0xFF;
}

function colorIntToRgb(color) {
    const b = color % 4;
    const g = (color >> 2) % 4;
    const r = (color >> 4) % 4;
    return [mapColor(r), mapColor(g), mapColor(b)];
}

function colorIntToHex(color) {
    const [r, g, b] = colorIntToRgb(color);
    return `#${((r * Math.pow(2,16)) + (g * Math.pow(2,8)) + b).toString(16).padStart(6, "0")}`;
}

function colorIntToABGR(color) {
    const [r, g, b] = colorIntToRgb(color);
    return (0xFF  * Math.pow(2,24)) + (b * Math.pow(2,16)) + (g * Math.pow(2,8)) + r;
}

function rgbToColorInt(r, g, b) {
    return (r << 4) + (g << 2) + b
}

function createColorPicker(canvas) {
    const colors = 4;

    const colorPicker = document.getElementById("color-picker");
    colorPicker.width = colors*colors;
    colorPicker.height = colors;

    const ctx = colorPicker.getContext("2d", { alpha: false });

    const imageData = new ImageData(colors*colors, colors);
    const data = new Uint32Array(imageData.data.buffer);

    const colorMap = new Map();

    for (let r = 0; r < colors; r++) {
        for (let g = 0; g < colors; g++) {
            for (let b = 0; b < colors; b++) {
                const index =  ((r * colors) + (g * colors * colors) + b);
                const colorInt = rgbToColorInt(r,g,b);
                
                data[index] = colorIntToABGR(colorInt);
                colorMap.set(index, colorInt);
            }
        }
    }

    ctx.putImageData(imageData, 0, 0);
    canvas.parentElement.appendChild(colorPicker);
    return [colorPicker, colorMap];
}

let hooks = {
    canvas: {
        mounted() {
            const canvas = this.el;
            const context = canvas.getContext("2d", { alpha: false });

            this.handleEvent("initialize-pixels", ({ pixels, canvasSize }) => {
                const chunk = new Uint8Array(new TextEncoder().encode(pixels));

                const imageData = new ImageData(canvasSize, canvasSize);
                const data = new Uint32Array(imageData.data.buffer);

                for (let i = 0; i < canvasSize * canvasSize; i++) {
                    data[i] = colorIntToABGR(chunk[i]);
                }

                context.putImageData(imageData, 0, 0);

                const [colorPicker, colorMap] = createColorPicker(canvas);

                const pixelSelect = document.getElementById("pixel-select");

                colorPicker.addEventListener("click", (event) => {
                    if (canvas.hasAttribute("x") && canvas.hasAttribute("y")) {
                        const bounding = colorPicker.getBoundingClientRect();
                        const pixelX = Math.floor(((event.clientX - bounding.left) / bounding.width) * 16);
                        const pixelY = Math.floor(((event.clientY - bounding.top) / bounding.height) * 4);
                        this.pushEvent("request-update-pixel", { x: parseInt(canvas.getAttribute("x")), y: parseInt(canvas.getAttribute("y")), color: colorMap.get(pixelX + (pixelY * 16)) })
                    }
                });

                canvas.addEventListener("click", (event) => {
                    const bounding = canvas.getBoundingClientRect();
                    const pixelX = Math.floor(((event.clientX - bounding.left) / bounding.width) * canvasSize);
                    const pixelY = Math.floor(((event.clientY - bounding.top) / bounding.height) * canvasSize);

                    pixelSelect.style.width = `${bounding.width/canvasSize}px`;
                    pixelSelect.style.height = `${bounding.height/canvasSize}px`;
                    pixelSelect.style.left = `${((pixelX / canvasSize) * bounding.width) + bounding.left}px`;
                    pixelSelect.style.top = `${((pixelY / canvasSize) * bounding.height) + bounding.top}px`;
                    pixelSelect.style.removeProperty("display");
                    console.log(bounding)
                    
                    canvas.setAttribute("x", pixelX);
                    canvas.setAttribute("y", pixelY);
                });
            });
            
            this.handleEvent("update-pixel", ({ x, y, color }) => {
                context.fillStyle = colorIntToHex(color);
                context.fillRect(x, y, 1, 1);
            });

            this.pushEvent("request-pixels", {});
        }
    }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
