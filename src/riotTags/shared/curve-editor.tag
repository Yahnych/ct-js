//
    Displays an editable curve with a grid, point editor and scales.

    @attribute curve (riot Array<ValueStep<number>>)
        @see https://pixijs.io/pixi-particles/docs/interfaces/valuestep.html
    @attribute onchange (riot function)
        Called when a user drags a curve's point.
        Passes the whole curve and an edited point as its arguments.

    @attribute lockstarttime (atomic)
        Locks the time of the firts point in the curve.
        Also, it forbids the deletion of this point.
    @attribute lockendtime (atomic)
        Locks the time of the last point in the curve.
        Also, it forbids the deletion of this point.
    @attribute lockstartvalue (atomic)
        Locks the value of the first point in the curve.
        Also, it forbids the deletion of this point.
    @attribute lockendvalue (atomic)
        Locks the value of the last point in the curve.
        Also, it forbids the deletion of this point.

    @attribute timestep (number)
        A step size for a manual point editor. Defaults to 0.01.
    @attribute valuestep (number)
        A step size for a manual point editor. Defaults to 0.01.

    @attribute easing (string, 'linear'|'none')
        Defaults to 'linear'.

curve-editor(ref="root")
    span(if="{!curve || min === void 0 || max === void 0}") Error :c
    span(if="{curve && min !== void 0 && max !== void 0 && width !== void 0 && height !== void 0}")
        .curve-editor-aGraphWrap
            .curve-editor-aRuler.flexrow
                span(each="{pos in [0, 0.2, 0.4, 0.6, 0.8, 1]}") {niceNumber(minTime + (pos * (maxTime - minTime)))}
            .curve-editor-aRuler.flexcol
                span(each="{pos in [1, 0.8, 0.6, 0.4, 0.2, 0]}") {niceNumber(min + (pos * (max - min)))}
            svg(xmlns="http://www.w3.org/2000/svg" riot-viewbox="0 0 {width} {height}" ref="graph" onmousemove="{onGraphMouseMove}")
                g.curve-editor-aGrid
                    polyline(
                        each="{pos in [0, 0.2, 0.4, 0.5, 0.6, 0.8, 1]}"
                        riot-points="0,{pos * height} {width},{pos * height}"
                        class="{aMiddleLine: pos === 0.5}"
                    )
                    polyline(
                        each="{pos in [0, 0.2, 0.4, 0.5, 0.6, 0.8, 1]}"
                        riot-points="{pos * width},0 {pos * width},{height}"
                        class="{aMiddleLine: pos === 0.5}"
                    )
                g.curve-editor-aCurve
                    polyline(
                        each="{point, ind in curve}"
                        riot-points="\
                            {(point.time - minTime) / maxTime * width},{(1 - (point.value - min) / (max-min)) * height}\
                            {(curve[ind+1].time - minTime) / maxTime * width},{(1 - ((parent.opts.easing === 'none'? point : curve[ind+1]).value - min) / (max-min)) * height}\
                        "
                        if="{ind !== curve.length - 1}"
                        onmousedown="{addPointOnSegment}"
                        title="{voc.curveLineHint}"
                    )
            .aDragger(
                each="{point in curve}"
                style="\
                    left: {(point.time - minTime) / maxTime * width}px;\
                    bottom: {(point.value - min) / (max-min) * height}px;\
                    {movedPoint? 'pointer-events: none;' : ''}\
                "
                class="{selected: selectedPoint === point}"
                onmousedown="{startMoving(point)}"
                oncontextmenu="{deletePoint}"
                title="{voc.dragPointHint}"
            )
        div
            label.fifty.npl.npb.nmt
                span {voc.pointTime}
                input(
                    type="number"
                    min="{minTime}" max="{maxTime}"
                    step="{opts.timestep || 0.01}"
                    value="{selectedPoint.time}"
                    oninput="{wireAndChange('this.selectedPoint.time')}"
                    disabled="{(opts.lockstarttime && selectedPoint === opts.curve[0]) || (opts.lockendtime && selectedPoint === opts.curve[opts.curve.length - 1])}"
                )
            label.fifty.npr.npb.nmt
                span {voc.pointValue}
                input(
                    type="number"
                    min="{min}" max="{max}"
                    step="{opts.valuestep || 0.01}"
                    value="{selectedPoint.value}"
                    oninput="{wireAndChange('this.selectedPoint.value')}"
                    disabled="{(opts.lockstartvalue && selectedPoint === opts.curve[0]) || (opts.lockendvalue && selectedPoint === opts.curve[opts.curve.length - 1])}"
                )
            .clear
    script.
        this.namespace = 'curveEditor';
        this.mixin(window.riotVoc);
        this.mixin(window.riotWired);

        this.wireAndChange = path => e => {
            this.wire(path)(e);
            if (this.opts.onchange) {
                this.opts.onchange(this.curve, this.movedPoint);
            }
        };

        this.selectedPoint = this.opts.curve[0];

        this.niceNumber = number => {
            if (number < 10 && number > -10) {
                return number.toPrecision(2);
            }
            return Math.round(number);
        };
        this.updateLayout = () => {
            this.selectedPoint = this.opts.curve[0];
            const box = this.refs.root.getBoundingClientRect();
            this.curve = this.opts.curve || [{
                time: 0,
                value: 0
            }, {
                time: 1,
                value: 1
            }];
            this.width = box.width;
            this.height = Number(this.opts.height || 200);
            this.min = Number(this.opts.min || 0);
            this.max = Number(this.opts.max || 1);
            this.minTime = Number(this.opts.mintime || 0);
            this.maxTime = Number(this.opts.maxtime || 1);
            this.update();
        };
        setTimeout(this.updateLayout, 0);

        const pointToLocation = point => ({
            x: point.time * this.width,
            y: (1 - (point.value - this.min) / this.max) * height
        });
        let startMoveX, startMoveY, oldTime, oldValue;
        this.startMoving = point => e => {
            this.selectedPoint = point;
            if (e.button !== 0) {
                return;
            }
            this.movedPoint = point;
            startMoveX = e.screenX;
            startMoveY = e.screenY;
            oldTime = point.time;
            oldValue = point.value;
        };
        this.onGraphMouseMove = e => {
            if (!this.movedPoint) {
                return;
            }
            const dx = e.screenX - startMoveX;
            const dy = e.screenY - startMoveY;
            const box = this.refs.graph.getBoundingClientRect();
            if ((!this.opts.lockstarttime || this.movedPoint !== this.curve[0]) &&
                (!this.opts.lockendtime || this.movedPoint !== this.curve[this.curve.length - 1])
            ) {
                this.movedPoint.time = oldTime + dx / box.width * (this.maxTime - this.minTime);
                this.movedPoint.time = Math.min(Math.max(this.movedPoint.time, this.minTime), this.maxTime);
            }
            if ((!this.opts.lockstartvalue || this.movedPoint !== this.curve[0]) &&
                (!this.opts.lockendvalue || this.movedPoint !== this.curve[this.curve.length - 1])
            ) {
                this.movedPoint.value = oldValue - dy / box.height * (this.max - this.min);
                this.movedPoint.value = Math.min(Math.max(this.movedPoint.value, this.min), this.max);
            }
            this.curve.sort((a, b) => a.time - b.time);
            this.update();
            if (this.opts.onchange) {
                this.opts.onchange(this.curve, this.movedPoint);
            }
        };

        this.addPointOnSegment = e => {
            const gx = e.layerX,
                  gy = e.layerY;
            const point = {
                time: gx / this.width * (this.maxTime - this.minTime) + this.minTime,
                value: (1 - gy / this.height) * (this.max - this.min)
            };
            this.curve.push(point);
            this.curve.sort((a, b) => a.time - b.time);
            if (this.opts.onchange) {
                this.opts.onchange(this.curve, this.movedPoint);
            }
            /* Start dragging the same point */
            this.startMoving(point)(e);
        };
        this.deletePoint = e => {
            const o = this.opts;
            if (e.item.point === this.curve[0] && (o.lockstarttime || o.lockstartvalue)) {
                return;
            }
            if (e.item.point === this.curve[this.curve.length - 1] && (o.lockendtime || o.lockendvalue)) {
                return;
            }
            const ind = o.curve.indexOf(e.item.point);
            if (ind !== -1) {
                const spliced = o.curve.splice(ind, 1);
                if (spliced[0] === this.selectedPoint) {
                    this.selectedPoint = o.curve[0];
                }
                if (this.opts.onchange) {
                    this.opts.onchange(this.curve, this.movedPoint);
                }
            }
        };

        const onMouseUp = e => {
            this.movedPoint = false;
        };
        this.on('mount', () => {
            document.addEventListener('mouseup', onMouseUp);
        });
        this.on('unmount', () => {
            document.removeEventListener('mouseup', onMouseUp);
        });
