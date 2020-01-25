emitter-editor.panel.pad
    .emitter-editor-aHeader
        img.emitter-editor-aTexture(src="{getPreview()}")
        h3 {voc.emitterHeading} {opts.emitter.uid.split('-').pop()}

    h3.nmt {voc.appearanceHeading}

    fieldset
        b {voc.texture}
        br
        button(onclick="{showTexturesSelector}").nml {voc.selectTexture}
        button(onclick="{showParticleImported}") {voc.importBuiltin}

    fieldset
        label
            b {voc.color}
            gradient-input(gradient="{opts.emitter.settings.color.list}" type="color" stepped="{opts.emitter.settings.color.isStepped}")
        label.checkbox
            input(
                type="checkbox" checked="{opts.emitter.settings.color.isStepped}"
                onchange="{wireAndReset('this.opts.emitter.settings.color.isStepped')}"
            )
            b {voc.stepped}
        label
            b {voc.alpha}
            gradient-input(gradient="{opts.emitter.settings.alpha.list}" type="float" stepped="{opts.emitter.settings.alpha.isStepped}")
        label.checkbox
            input(
                type="checkbox" checked="{opts.emitter.settings.alpha.isStepped}"
                onchange="{wireAndReset('this.opts.emitter.settings.alpha.isStepped')}"
            )
            b {voc.stepped}

    fieldset
        label
            b {voc.scale}
            curve-editor(
                min="0" max="5"
                valuestep="0.1"
                easing="{opts.emitter.settings.scale.isStepped? 'none' : 'linear'}"
                curve="{opts.emitter.settings.scale.list}"
                lockstarttime="true" lockendtime="true"
                onchange="{updateScaleCurve}"
            )
        label.checkbox
            input(
                type="checkbox" checked="{opts.emitter.settings.scale.isStepped}"
                onchange="{wireAndReset('this.opts.emitter.settings.scale.isStepped')}"
            )
            b {voc.stepped}
        label
            b {voc.minimumSize}
            input(
                type="range" min="0" max="1" step="0.01"
                value="{opts.emitter.settings.minimumScaleMultiplier}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.minimumScaleMultiplier', 'minimumScaleMultiplier', true)}"
            )

    fieldset
        label
            b {voc.blendMode}
            select(onchange="{wireAndReset('this.opts.emitter.settings.blendMode')}")
                option(value="normal" selected="{opts.emitter.settings.blendMode === 'normal'}") {voc.regular}
                option(value="multiply" selected="{opts.emitter.settings.blendMode === 'multiply'}") {voc.darken}
                option(value="screen" selected="{opts.emitter.settings.blendMode === 'screen'}") {voc.lighten}
                option(value="add" selected="{opts.emitter.settings.blendMode === 'add'}") {voc.burn}

    h3 {voc.motionHeading}

    fieldset
        label
            b {voc.speed}
            curve-editor(
                min="0" max="2500"
                valuestep="10"
                easing="{opts.emitter.settings.speed.isStepped? 'none' : 'linear'}"
                curve="{opts.emitter.settings.speed.list}"
                lockstarttime="true" lockendtime="true"
                onchange="{updateSpeedCurve}"
            )
        label.checkbox
            input(
                type="checkbox" checked="{opts.emitter.settings.speed.isStepped}"
                onchange="{wireAndReset('this.opts.emitter.settings.speed.isStepped')}"
            )
            b {voc.stepped}
        label
            b {voc.minimumSpeed}
            input(
                type="range" min="0" max="1" step="0.01"
                value="{opts.emitter.settings.minimumSpeedMultiplier}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.minimumSpeedMultiplier', 'minimumSpeedMultiplier', true)}"
            )

    fieldset
        b {voc.startingDirection}
        br
        label.fifty.npt.npl.nmt
            span {voc.from}
            input.wide(
                type="number" step="1" min="-360" max="360"
                value="{opts.emitter.settings.startRotation.min}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.startRotation.min', 'minStartRotation', true)}"
            )
        label.fifty.npt.npr.nmt
            span {voc.to}
            input.wide(
                type="number" step="1" min="-360" max="360"
                value="{opts.emitter.settings.startRotation.max}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.startRotation.max', 'maxStartRotation', true)}"
            )
        .clear
        label
            b {voc.preserveTextureDirection}
            input(type="checkbox" checked="{opts.emitter.settings.noRotation}" onchange="{wireAndReset('this.opts.emitter.settings.noRotation')}")

    fieldset
        b {voc.rotationSpeed}
        br
        label.fifty.npt.npl.npb.nmt
            span {voc.from}
            input.wide(
                type="number" step="1" min="-360" max="360"
                value="{opts.emitter.settings.rotationSpeed.min}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.rotationSpeed.min', 'minRotationSpeed', true)}"
            )
        label.fifty.npt.npr.npb.nmt
            span {voc.to}
            input.wide(
                type="number" step="1" min="-360" max="360"
                value="{opts.emitter.settings.rotationSpeed.max}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.rotationSpeed.max', 'maxRotationSpeed', true)}"
            )
        .clear

    h3 {voc.spawningHeading}

    fieldset
        label
            b {voc.timeBetweenBursts}
            input.wide(
                type="number" step="0.001" min="0.001" max="10"
                value="{opts.emitter.settings.frequency}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.frequency', 'frequency')}"
            )
        label
            b {voc.chanceToSpawn}
            input(
                type="range" min="0" max="1" step="0.01"
                value="{opts.emitter.settings.spawnChance}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.spawnChance', 'spawnChance')}"
            )
        label
            b {voc.maxParticles}
            input.wide(
                type="number" step="1" min="1" max="10000"
                value="{opts.emitter.settings.maxParticles}"
                oninput="{wireAndUpdate('this.opts.emitter.settings.maxParticles', 'maxParticles')}"
            )

    fieldset
        b {voc.lifetime}
        br
        label.fifty.npt.npl.npb.nmt
            span {voc.from}
            input.wide(
                type="number" step="0.01" min="0.01" max="600"
                value="{opts.emitter.settings.lifetime.min}"
                oninput="{wireAndReset('this.opts.emitter.settings.lifetime.min')}"
            )
        label.fifty.npt.npr.npb.nmt
            span {voc.to}
            input.wide(
                type="number" step="0.01" min="0.01" max="600"
                value="{opts.emitter.settings.lifetime.max}"
                oninput="{wireAndReset('this.opts.emitter.settings.lifetime.max')}"
            )
        .clear

    fieldset
        label
            b {voc.prewarmDelay}
            input.wide(type="number" min="-100" max="100" value="{opts.emitter.delay}" oninput="{wireAndReset('this.opts.emitter.delay')}")

    h3 {voc.positioningHeading}
    label
        b {voc.spawnType}
        select(onchange="{changeSpawnType}")
            option(value="point") {voc.spawnShapes.point}
            option(value="rect") {voc.spawnShapes.rectangle}
            option(value="circle") {voc.spawnShapes.circle}
            option(value="ring") {voc.spawnShapes.ring}
            option(value="burst") {voc.spawnShapes.star}

    // emitter.settings.spawnType === 'point' does not have additional settings

    fieldset(if="{opts.emitter.settings.spawnType === 'rect'}")
        label.fifty.npt.npl.npb.nmt
            b {voc.width}
            input.wide(
                type="number" step="1" min="-4096" max="4096"
                value="{opts.emitter.settings.spawnRect.w}"
                oninput="{setRectWidth}"
            )
        label.fifty.npt.npr.npb.nmt
            b {voc.height}
            input.wide(
                type="number" step="1" min="-4096" max="4096"
                value="{opts.emitter.settings.spawnRect.h}"
                oninput="{setRectHeight}"
            )
        .clear
    fieldset(if="{opts.emitter.settings.spawnType === 'circle'}")
        label
            b {voc.radius}
            input.wide(
                type="number" step="1" min="1" max="4096"
                value="{opts.emitter.settings.spawnCircle.r}"
                oninput="{wireAndReset('this.opts.emitter.settings.spawnCircle.r')}"
            )

    fieldset(if="{opts.emitter.settings.spawnType === 'ring'}")
        b {voc.radius}
        label.fifty.npt.npl.npb.nmt
            span {voc.from}
            input.wide(
                type="number" step="1" min="1" max="4096"
                value="{opts.emitter.settings.spawnCircle.minR}"
                oninput="{wireAndReset('this.opts.emitter.settings.spawnCircle.minR')}"
            )
        label.fifty.npt.npr.npb.nmt
            span {voc.to}
            input.wide(
                type="number" step="1" min="1" max="4096"
                value="{opts.emitter.settings.spawnCircle.r}"
                oninput="{wireAndReset('this.opts.emitter.settings.spawnCircle.r')}"
            )
        .clear

    fieldset(if="{opts.emitter.settings.spawnType === 'burst'}")
        label
            b {voc.starPoints}
            input.wide(
                type="number" min="1" max="128" step="1"
                value="{opts.emitter.settings.particlesPerWave}"
                oninput="{setParticleSpacing}"
            )

    fieldset
        b {voc.relativeEmitterPosition}
        label.fifty.npt.npl.npb.nmt
            b {voc.posX}
            input.wide(
                type="number" step="1" min="-360" max="360"
                value="{opts.emitter.settings.pos.x}"
                oninput="{wireAndReset('this.opts.emitter.settings.pos.x')}"
            )
        label.fifty.npt.npr.npb.nmt
            b {voc.posY}
            input.wide(
                type="number" step="1" min="-360" max="360"
                value="{opts.emitter.settings.pos.y}"
                oninput="{wireAndReset('this.opts.emitter.settings.pos.y')}"
            )
        .clear

    texture-selector(if="{pickingTexture}" onselected="{onTexturePicked}" oncancelled="{onTextureCancel}")
    particle-importer(if="{importingTexture}")
    script.
        this.namespace = 'particleEmitters';
        this.mixin(window.riotVoc);
        this.mixin(window.riotWired);

        const {getTexturePreview} = require('./data/node_requires/resources/textures');
        this.getPreview = () => {
            return getTexturePreview(this.opts.emitter.texture);
        };

        this.wireAndReset = path => e => {
            this.wire(path)(e);
            window.signals.trigger('emitterResetRequest');
        };
        this.wireAndUpdate = (path, field, useDirectValue) => e => {
            const val = this.wire(path)(e);
            if (this.opts.emittermap && (this.opts.emitter.uid in this.opts.emittermap)) {
                const emtInst = this.opts.emittermap[this.opts.emitter.uid];
                if (useDirectValue) {
                    emtInst[field] = val;
                } else {
                    emtInst[field] = this.opts.emitter[field];
                }
            } else {
                window.signals.trigger('emitterResetRequest');
            }
        };

        this.pickingTexture = false;

        this.setParticleSpacing = e => {
            const emt = this.opts.emitter.settings;
            emt.particleSpacing = 360 / Math.min(128, Math.max(1, Number(e.target.value)));
            emt.particlesPerWave = Number(e.target.value);
            window.signals.trigger('emitterResetRequest');
        };

        this.setRectWidth = e => {
            const emt = this.opts.emitter.settings;
            emt.spawnRect.w = Number(e.target.value);
            emt.spawnRect.x = -emt.spawnRect.w / 2;
            window.signals.trigger('emitterResetRequest');
        };
        this.setRectHeight = e => {
            const emt = this.opts.emitter.settings;
            emt.spawnRect.h = Number(e.target.value);
            emt.spawnRect.y = -emt.spawnRect.h / 2;
            window.signals.trigger('emitterResetRequest');
        };

        this.updateScaleCurve = curve => {
            if (this.opts.emittermap && (this.opts.emitter.uid in this.opts.emittermap)) {
                const emtInst = this.opts.emittermap[this.opts.emitter.uid];
                const {PropertyNode} = require('pixi-particles');
                emtInst.startScale = PropertyNode.createList(this.opts.emitter.settings.scale);
            } else {
                window.signals.trigger('emitterResetRequest');
            }
        };
        this.updateSpeedCurve = curve => {
            if (this.opts.emittermap && (this.opts.emitter.uid in this.opts.emittermap)) {
                const emtInst = this.opts.emittermap[this.opts.emitter.uid];
                const {PropertyNode} = require('pixi-particles');
                emtInst.startSpeed = PropertyNode.createList(this.opts.emitter.settings.speed);
            } else {
                window.signals.trigger('emitterResetRequest');
            }
        };

        this.changeSpawnType = e => {
            const emt = this.opts.emitter.settings;
            const type = e.target.value;
            emt.spawnType = type;
            if (type === 'rect') {
                emt.spawnRect = {
                    x: -100,
                    y: -100,
                    w: 200,
                    h: 200
                };
            } else if (type === 'circle' || type === 'ring') {
                emt.spawnCircle = {
                    x: 0,
                    y: 0,
                    r: 200,
                    minR: 100
                }
            } else if (type === 'burst') {
                emt.particlesPerWave = 5;
                emt.particleSpacing = 360 / 5;
            }
            window.signals.trigger('emitterResetRequest');
        };

        this.showTexturesSelector = e => {
            this.pickingTexture = true;
        };
        this.onTexturePicked = texture => e => {
            const emt = this.opts.emitter;
            emt.texture = texture.uid;
            this.pickingTexture = false;
            this.update();
            window.signals.trigger('emitterResetRequest');
        };
        this.onTextureCancel = () => {
            this.pickingTexture = false;
            this.update();
        };

        this.showParticleImported = e => {
            this.importingTexture = true;
        };