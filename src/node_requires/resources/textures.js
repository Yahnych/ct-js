/* global currentProject */

const getTextureFromId = id => {
    const texture = currentProject.textures.find(tex => tex.uid === id);
    if (!texture) {
        throw new Error(`Attempt to get a non-existent texture with ID ${id}`);
    }
    return texture;
};

let textureLoader;

const loadBaseTextureForCtTexture = texture => new Promise((resolve, reject) => {
    const PIXI = require('pixi.js-legacy');

    if (!textureLoader) {
        textureLoader = new PIXI.Loader();
    }
    const {resources} = textureLoader;
    // invalidate deleted textures
    for (const uid in resources) {
        if (!window.currentProject.textures.find(tex => tex.uid === uid)) {
            delete resources[uid];
        }
    }
    const path = 'file://' + sessionStorage.projdir + '/img/' + texture.origname + '?' + texture.lastmod;

    if (!(texture.uid in resources)) {
        textureLoader.add(texture.uid, path);
    } else if (resources[texture.uid].url !== path) { // invalidate outdated versions
        delete resources[texture.uid];
        textureLoader.add(texture.uid, path);
    }
    textureLoader.onError.add(reject);
    textureLoader.load(() => {
        resolve(resources[texture.uid].texture.baseTexture);
    });
});

let pixiTextureCache = {};
const clearPixiTextureCache = function () {
    pixiTextureCache = {};
    textureLoader = null;
};
/**
 * @param {any} tex A ct.js texture object
 * @returns {Array<PIXI.Texture>} An array of PIXI.Textures
 */
const textureArrayFromCtTexture = async function (tex) {
    const frames = [];
    const PIXI = require('pixi.js-legacy');
    const baseTexture = await loadBaseTextureForCtTexture(tex);
    for (var col = 0; col < tex.grid[1]; col++) {
        for (var row = 0; row < tex.grid[0]; row++) {
            const texture = new PIXI.Texture(
                baseTexture,
                new PIXI.Rectangle(
                    tex.offx + row * (tex.width + tex.marginx),
                    tex.offy + col * (tex.height + tex.marginy),
                    tex.width,
                    tex.height
                )
            );
            texture.defaultAnchor = new PIXI.Point(tex.axis[0] / tex.width, tex.axis[1] / tex.height);
            frames.push(texture);
            if (col * tex.grid[0] + row >= tex.grid.untill && tex.grid.untill > 0) {
                break;
            }
        }
    }
    return frames;
};

let defaultTexture;

/**
 * @param {string|-1|any} texture Either a uid of a texture, or a ct.js texture object
 * @param {number} [frame] The frame to extract. If not defined, will return an array of all frames
 * @param {boolean} [allowMinusOne] Allows the use of `-1` as a texture uid
 * @returns {Array<PIXI.Texture>|PIXI.Texture} An array of textures, or an individual one.
 */
const getPixiTexture = async function (texture, frame, allowMinusOne) {
    if (allowMinusOne && texture === -1) {
        if (!defaultTexture) {
            const PIXI = require('pixi.js-legacy');
            defaultTexture = PIXI.Texture.from('data/img/unknown.png');
        }
        return defaultTexture;
    }
    if (typeof texture === 'string') {
        texture = getTextureFromId(texture);
    }
    if (!pixiTextureCache[texture.uid] ||
        pixiTextureCache[texture.uid].lastmod !== texture.lastmod
    ) {
        const tex = await textureArrayFromCtTexture(texture);
        pixiTextureCache[texture.uid] = {
            lastmod: texture.lastmod,
            texture: tex
        };
    }
    if (frame || frame === 0) {
        return pixiTextureCache[texture.uid].texture[frame];
    }
    return pixiTextureCache[texture.uid].texture;
};

module.exports = {
    clearPixiTextureCache,
    getTextureFromId,
    getPixiTexture
};
