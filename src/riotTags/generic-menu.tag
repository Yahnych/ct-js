generic-menu(class="{opened: opts.menu.opened}" ref="root")
    label(each="{item in opts.menu.items}" class="{item.type || 'item'} {checkbox: item.type === 'checkbox'} {submenu: item.submenu}" disabled="{item.disabled}" onclick="{item.click}")
        i(class="icon-{item.icon instanceof Function? item.icon() : item.icon}" if="{item.icon && item.type !== 'separator' && item.type !== 'checkbox'}")
        input(type="checkbox" checked="{item.checked}" if="{item.type === 'checkbox'}")
        span(if="{!item.type !== 'separator'}") {item.label}
        generic-menu(if="{item.submenu && item.type !== 'separator'}" menu="{item.submenu}")
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
            if (e.target.closest('generic-menu') !== this.refs.root && !e.item.item.submenu) {
                e.target.closest('generic-menu').opened = false;
            } else {
                e.stopPropagation();
            }
        }
        this.on('mount', () => {
            document.addEventListener('click', clickListener);
        });
        this.on('unmount', () => {
            document.removeEventListener('click', clickListener);
        });
