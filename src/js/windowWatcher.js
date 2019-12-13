(function () {
    const {remote} = require('electron');
    const win = remote.getCurrentWindow();
    var lastState = 'normal';

    const saveState = function () {
        localStorage.windowSettings = JSON.stringify({
            mode: win.isFullscreen()? 'fullscreen' : lastState,
            x: win.getPosition()[0],
            y: win.getPosition()[1],
            width: win.getSize()[0],
            height: win.getSize()[1]
        });
    };
    win.on('restore', () => {
        lastState = 'normal';
        saveState();
    });
    win.on('maximize', () => {
        lastState = 'maximized';
        saveState();
    });
    win.on('unmaximize', function () {
        lastState = 'normal';
        saveState();
    });
    win.on('move', function () {
        lastState = 'normal';
        saveState();
    });
    win.window.addEventListener('resize', function () {
        saveState();
    });
    win.on('close', function () {
        saveState();
    });

    const settings = localStorage.windowSettings? JSON.parse(localStorage.windowSettings) : {
        mode: 'center'
    };
    if (settings.mode === 'center') {
        win.setPosition('center');
    } else if (settings.mode === 'fullscreen') {
        win.enterFullscreen();
    } else if (settings.mode === 'maximized') {
        win.maximize();
    } else if (settings.mode === 'normal') {
        const {screens} = nw.Screen;
        var locationIsOnAScreen = false;
        for (const screen of screens) {
            if (settings.x > screen.bounds.x && settings.x < screen.bounds.x + screen.bounds.width) {
                if (settings.y > screen.bounds.y && settings.y < screen.bounds.y + screen.bounds.height) {
                    locationIsOnAScreen = true;
                }
            }
        }

        if (!locationIsOnAScreen) {
            win.setPosition('center');
        } else {
            win.width = settings.width;
            win.height = settings.height;
            win.x = settings.x;
            win.y = settings.y;
        }
    }
})();
