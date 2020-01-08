emitter-tandem-editor.panel.view.flexrow
    .flexfix(style="width: {panelWidth}px")
        .flexfix-header
            .panel.pad
                b {vocGlob.name}
                br
                input.wide(type="text" value="{tandem.name}" onchange="{wire('this.tandem.name')}")
                .anErrorNotice(if="{nameTaken}" ref="errorNotice") {vocGlob.nametaken}
        .flexfix-body.flexrow
            emitter-editor(
                each="{emitter in tandem.emitters}"
                emitter="{emitter}"
                emittermap="{parent.uidToEmitterMap}"
            )
            button.emitter-tandem-editor-anAddEmitterButton(onclick="{addEmitter}")
                svg.feather
                    use(xlink:href="data/icons.svg#plus")
                span {voc.addEmitter}
        .flexfix-footer
            button.wide(onclick="{apply}")
                svg.feather
                    use(xlink:href="data/icons.svg#check")
                span {vocGlob.apply}
    .aResizer.vertical(onmousedown="{gutterMouseDown}")
    div(ref="preview")
        canvas(ref="canvas")
        button.emitter-tandem-editor-aResetEmittersButton(onclick="{resetEmitters}")
            span {voc.reset}
    script.
        this.tandem = this.opts.tandem;

        this.namespace = 'particleEmitters';
        this.mixin(window.riotVoc);
        this.mixin(window.riotWired);

        /*
            Logic of resizeable panel goes here
        */
        const minSizeW = 20 * 16;
        const getMaxSizeW = () => window.innerWidth - 128;
        this.panelWidth = Math.max(minSizeW, Math.min(getMaxSizeW(), localStorage.particlesPanelWidth || 20 * 32));
        this.gutterMouseDown = e => {
            this.draggingGutter = true;
        };
        const gutterMove = e => {
            if (!this.draggingGutter) {
                return;
            }
            this.panelWidth = Math.max(minSizeW, Math.min(getMaxSizeW(), e.clientX));
            localStorage.particlesPanelWidth = this.panelWidth;
            this.update();
            this.updatePreviewLayout();
        };
        const gutterUp = () => {
            if (this.draggingGutter) {
                this.draggingGutter = false;
            }
        };
        document.addEventListener('mousemove', gutterMove);
        document.addEventListener('mouseup', gutterUp);
        this.on('unmount', () => {
            document.removeEventListener('mousemove', gutterMove);
            document.removeEventListener('mouseup', gutterUp);
        });

        /*
            Rendering and spawning emitters
        */
        const PIXI = require('pixi.js-legacy');
        const stage = new PIXI.Container();
        this.uidToEmitterMap = {};

        // Creates a new emitter
        this.spawnEmitter = async (emitterData, container) => {
            const particles = require('pixi-particles');
            const {getPixiTexture} = require('./data/node_requires/resources/textures');
            const textures = await getPixiTexture(emitterData.texture, null, true);
            const emitter = new particles.Emitter(
                container,
                textures,
                emitterData.settings
            );
            emitter.emit = true;
            this.uidToEmitterMap[emitterData.uid] = emitter;
            return emitter;
        };
        // Recreates all the emitters
        this.resetEmitters = async () => {
            if (this.emitterInstances && this.emitterInstances.length) {
                for (const emitter of this.emitterInstances) {
                    emitter.destroy();
                }
            }
            this.emitterInstances = [];
            this.uidToEmitterMap = {};
            await Promise.all(
                this.tandem.emitters
                .map(emitterData => this.spawnEmitter(emitterData, this.emitterContainer))
            ).then(emitters =>
                this.emitterInstances.push(...emitters)
            );
            this.update(); // Need to update the riot tag so that editors get their link to emitter instances
        };
        // Advances emitter simulation by a given amount of seconds
        this.updateEmitters = seconds => {
            for (const emitter of this.emitterInstances) {
                emitter.update(seconds);
            }
        };

        // Fits the canvas to the available space
        this.updatePreviewLayout = () => {
            if (this.renderer && this.refs.canvas) {
                const box = this.refs.preview.getBoundingClientRect();
                const canvas = this.refs.canvas;
                canvas.width = Math.round(box.width);
                canvas.height = Math.round(box.height);
                this.renderer.resize(canvas.width, canvas.height);
                this.emitterContainer.x = canvas.width / 2;
                this.emitterContainer.y = canvas.height / 2;
            }
        };

        let elapsed = Date.now();
        // Advances emitter simulation and renders the stage
        const render = () => {
            // Update the next frame
            updateId = requestAnimationFrame(render);
            const now = Date.now();
            this.updateEmitters((now - elapsed) * 0.001);
            elapsed = now;
            this.renderer.render(stage);
        };

        this.on('mount', () => {
            window.addEventListener('resize', this.updatePreviewLayout);

            const box = this.refs.preview.getBoundingClientRect();

            this.renderer = new PIXI.Renderer({
                width: Math.round(box.width),
                height: Math.round(box.height),
                view: this.refs.canvas
            });
            this.emitterContainer = new PIXI.ParticleContainer();
            stage.addChild(this.emitterContainer);

            this.emitterContainer.setProperties({
                scale: true,
                position: true,
                rotation: true,
                uvs: true,
                alpha: true
            });

            this.resetEmitters();
            this.updatePreviewLayout();
            render();

            window.signals.on('emitterResetRequest', this.resetEmitters);
        });
        this.on('unmount', () => {
            window.removeEventListener('resize', this.updatePreviewLayout);
            window.signals.off('emitterResetRequest', this.resetEmitters);
        });

        /*
            UI events
        */
        this.addEmitter = e => {
            const defaultEmitter = require('./data/node_requires/resources/particles/defaultEmitter').get();
            this.tandem.emitters.push(defaultEmitter);
            this.resetEmitters();
        };

        this.apply = e => {
            this.parent.editingTandem = false;
            this.parent.update();
        };
