/* eslint-disable camelcase */
const electron = require('electron');

const createWindows = () => {
    const mainWindow = new electron.BrowserWindow({
        width: 1024,
        height: 720,
        min_width: 380,
        min_height: 380,
        center: true,
        resizable: true,

        title: 'ct.js',
        icon: 'ct_ide.png',

        webPreferences: {
            nodeIntegration: true,
            defaultFontFamily: 'sansSerif',
            backgroundThrottling: true
        }
    });
    mainWindow.loadFile('index.html');
    mainWindow.webContents.openDevTools();
};


electron.app.on('ready', createWindows);
