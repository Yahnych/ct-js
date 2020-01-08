//
    Displays an editable curve with a grid and scales.

    @attribute curve (riot Array<ValueStep<number>>)
        @see https://pixijs.io/pixi-particles/docs/interfaces/valuestep.html
    @attribute onchange (riot function)
        Called when a user drags a curve's point.
        Passes the whole curve and an edited point as its arguments.

    @attribute lockstarttime (atomic)
        Locks the time of the firts point in the curve.
    @attribute lockendtime (atomic)
        Locks the time of the last point in the curve.
    @attribute lockstartvalue (atomic)
        Locks the value of the first point in the curve.
    @attribute lockendvalue (atomic)
        Locks the value of the last point in the curve.

    @attribute easing (string, 'linear'|'none')

curve-editor(ref="root")
    span(if="{!curve || min === void 0 || max === void 0}") Error :c
    span(if="{curve && min !== void 0 && max !== void 0}")
        .curve-editor-aRuler.flexrow
            span(each="{pos in [0, 0.2, 0.4, 0.6, 0.8, 1]}") {niceNumber(minTime + (pos * (maxTime - minTime)))}
        .curve-editor-aRuler.flexcol
            span(each="{pos in [1, 0.8, 0.6, 0.4, 0.2, 0]}") {niceNumber(min + (pos * (max - min)))}
        .curve-editor-aGraphWrap
            svg(xmlns="http://www.w3.org/2000/svg" viewbox="0 0 {width} {height}" ref="graph" onmousemove="{onGraphMouseMove}")
                g.curve-editor-aGrid
                    polyline(
                        each="{pos in [0, 0.2, 0.4, 0.5, 0.6, 0.8, 1]}"
                        points="0,{pos * height} {width},{pos * height}"
                        class="{aMiddleLine: pos === 0.5}"
                    )
                    polyline(
                        each="{pos in [0, 0.2, 0.4, 0.5, 0.6, 0.8, 1]}"
                        points="{pos * width},0 {pos * width},{height}"
                        class="{aMiddleLine: pos === 0.5}"
                    )
                g.curve-editor-aCurve
                    polyline(
                        each="{point, ind in curve}"
                        points="\
                            {(point.time - minTime) / maxTime * width},{(1 - (point.value - min) / (max-min)) * height}\
                            {(curve[ind+1].time - minTime) / maxTime * width},{(1 - ((opts.easing === 'none'? point : curve[ind+1]).value - min) / (max-min)) * height}\
                        "
                        if="{ind !== curve.length - 1}"
                        onclick="{addPointOnSegment}"
                    )
            .aDragger(
                each="{point in curve}"
                style="\
                    left: {(point.time - minTime) / maxTime * width}px;\
                    bottom: {(point.value - min) / (max-min) * height}px\
                "
                onmousedown="{startMoving(point)}"
            )
    script.
        this.niceNumber = number => {
            if (number < 10 && number > -10) {
                return number.toPrecision(2);
            }
            return Math.round(number);
        }
        this.updateLayout = () => {
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
        const onMouseUp = e => {
            this.movedPoint = false;
        };
        this.on('mount', () => {
            document.addEventListener('mouseup', onMouseUp);
        });
        this.on('unmount', () => {
            document.removeEventListener('mouseup', onMouseUp);
        });