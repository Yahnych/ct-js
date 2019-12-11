generic-menu(class="{opened: opts.menu.opened}" ref="root")
    label(each="{item in opts.menu}" class="{item.type || 'item'} {checkbox: item.type === 'checkbox'}" disabled="{item.disabled}" onclick="{item.click}")
        i(class="icon-{item.icon}" if="{item.icon && item.type !== 'separator' && item.type !== 'checkbox'}")
        input(type="checkbox" checked="{item.checked}")
        span(if="{!item.type === 'separator'}") {item.label}
        generic-menu(if="{item.submenu && item.type !== 'separator'}")
    script.
        this.onItemClick = e => {
            if (e.item.item.onclick) {
                e.item.item.onclick();
            }
            this.opened = false;
        };

        this.popup = (x, y) => {
            this.style.left = x + 'px';
            this.style.top = y + 'px';
            this.opened = true;
        };

        this.toggle = () => {
            this.opened = !this.opened;
            this.update();
        };
        this.open = () => {
            this.opened = true;
            this.update();
        };
        this.close = () => {
            this.opened = false;
            this.update();
        };
        this.popup = () => {

        }
        const clickListener = e => {
            if (!e.target.closest(this.refs.root)) {
                this.opened = false;
            }
        }
        this.on('mount', () => {
            document.addEventListener('click', clickListener);
        });
        this.on('unmount', () => {
            document.removeEventListener('click', clickListener);
        });
