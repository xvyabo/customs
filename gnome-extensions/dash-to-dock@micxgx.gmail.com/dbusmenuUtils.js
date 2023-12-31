// -*- mode: js; js-indent-level: 4; indent-tabs-mode: nil -*-

import {
    Atk,
    Clutter,
    Gio,
    GLib,
    St
} from './dependencies/gi.js';

import {PopupMenu} from './dependencies/shell/ui.js';

import {Utils} from './imports.js';

// Dbusmenu features not (yet) supported:
//
//   * The CHILD_DISPLAY property
//
//     This seems to have only one possible value in the Dbusmenu API, so
//     there's little point in depending on it--the code in libdbusmenu sets it
//     if and only if an item has children, so for our purposes it's simpler
//     and more intuitive to just check children.length. (This does ignore the
//     possibility of a program not using libdbusmenu and setting CHILD_DISPLAY
//     independently, perhaps to indicate that an childless menu item should
//     nevertheless be displayed like a submenu.)
//
//   * Children more than two levels deep
//
//     PopupMenu doesn't seem to support submenus in submenus.
//
//   * Shortcut keys
//
//     If these keys are supposed to be installed as global shortcuts, we'd
//     have to query these aggressively and not wait for the DBus menu to be
//     mapped to a popup menu. A shortcut key that only works once the popup
//     menu is open and has key focus is possibly of marginal value.

/**
 *
 */
export async function haveDBusMenu() {
    try {
        const {default: DBusMenu} = await import('gi://Dbusmenu');
        return DBusMenu;
    } catch (e) {
        log(`Failed to import DBusMenu, quicklists are not available: ${e}`);
        return null;
    }
}

const DBusMenu = await haveDBusMenu();

/**
 * @param dbusmenuItem
 * @param deep
 */
export function makePopupMenuItem(dbusmenuItem, deep) {
    // These are the only properties guaranteed to be available when the root
    // item is first announced. Other properties might be loaded already, but
    // be sure to connect to Dbusmenu.MENUITEM_SIGNAL_PROPERTY_CHANGED to get
    // the most up-to-date values in case they aren't.
    const itemType = dbusmenuItem.property_get(DBusMenu.MENUITEM_PROP_TYPE);
    const label = dbusmenuItem.property_get(DBusMenu.MENUITEM_PROP_LABEL);
    const visible = dbusmenuItem.property_get_bool(DBusMenu.MENUITEM_PROP_VISIBLE);
    const enabled = dbusmenuItem.property_get_bool(DBusMenu.MENUITEM_PROP_ENABLED);
    const accessibleDesc = dbusmenuItem.property_get(DBusMenu.MENUITEM_PROP_ACCESSIBLE_DESC);
    // const childDisplay = dbusmenuItem.property_get(Dbusmenu.MENUITEM_PROP_CHILD_DISPLAY);

    let item;
    const signalsHandler = new Utils.GlobalSignalsHandler();
    const wantIcon = itemType === DBusMenu.CLIENT_TYPES_IMAGE;

    // If the basic type of the menu item needs to change, call this.
    const recreateItem = () => {
        const newItem = makePopupMenuItem(dbusmenuItem, deep);
        const parentMenu = item._parent;
        parentMenu.addMenuItem(newItem);
        // Reminder: Clutter thinks of later entries in the child list as
        // "above" earlier ones, so "above" here means "below" in terms of the
        // menu's vertical order.
        parentMenu.actor.set_child_above_sibling(newItem.actor, item.actor);
        if (newItem.menu)
            parentMenu.actor.set_child_above_sibling(newItem.menu.actor, newItem.actor);

        parentMenu.actor.remove_child(item.actor);
        item.destroy();
        item = null;
    };

    const updateDisposition = () => {
        const disposition = dbusmenuItem.property_get(DBusMenu.MENUITEM_PROP_DISPOSITION);
        let iconName = null;
        switch (disposition) {
        case DBusMenu.MENUITEM_DISPOSITION_ALERT:
        case DBusMenu.MENUITEM_DISPOSITION_WARNING:
            iconName = 'dialog-warning-symbolic';
            break;
        case DBusMenu.MENUITEM_DISPOSITION_INFORMATIVE:
            iconName = 'dialog-information-symbolic';
            break;
        }
        if (iconName) {
            item._dispositionIcon = new St.Icon({
                icon_name: iconName,
                style_class: 'popup-menu-icon',
                y_align: Clutter.ActorAlign.CENTER,
                y_expand: true,
            });
            let expander;
            for (let child = item.label.get_next_sibling(); ; child = child.get_next_sibling()) {
                if (!child) {
                    expander = new St.Bin({
                        style_class: 'popup-menu-item-expander',
                        x_expand: true,
                    });
                    item.actor.add_child(expander);
                    break;
                } else if (child instanceof St.Widget &&
                           child.has_style_class_name('popup-menu-item-expander')) {
                    expander = child;
                    break;
                }
            }
            item.actor.insert_child_above(item._dispositionIcon, expander);
        } else if (item._dispositionIcon) {
            item.actor.remove_child(item._dispositionIcon);
            item._dispositionIcon = null;
        }
    };

    const updateIcon = () => {
        if (!wantIcon)
            return;

        const iconData = dbusmenuItem.property_get_byte_array(DBusMenu.MENUITEM_PROP_ICON_DATA);
        const iconName = dbusmenuItem.property_get(DBusMenu.MENUITEM_PROP_ICON_NAME);
        if (iconName)
            item.icon.icon_name = iconName;
        else if (iconData.length)
            item.icon.gicon = Gio.BytesIcon.new(iconData);
    };

    const updateOrnament = () => {
        const toggleType = dbusmenuItem.property_get(DBusMenu.MENUITEM_PROP_TOGGLE_TYPE);
        switch (toggleType) {
        case DBusMenu.MENUITEM_TOGGLE_CHECK:
            item.actor.accessible_role = Atk.Role.CHECK_MENU_ITEM;
            break;
        case DBusMenu.MENUITEM_TOGGLE_RADIO:
            item.actor.accessible_role = Atk.Role.RADIO_MENU_ITEM;
            break;
        default:
            item.actor.accessible_role = Atk.Role.MENU_ITEM;
        }
        let ornament = PopupMenu.Ornament.NONE;
        const state = dbusmenuItem.property_get_int(DBusMenu.MENUITEM_PROP_TOGGLE_STATE);
        if (state === DBusMenu.MENUITEM_TOGGLE_STATE_UNKNOWN) {
            // PopupMenu doesn't natively support an "unknown" ornament, but we
            // can hack one in:
            item.setOrnament(ornament);
            item.actor.add_accessible_state(Atk.StateType.INDETERMINATE);
            item._ornamentLabel.text = '\u2501';
            item.actor.remove_style_pseudo_class('checked');
        } else {
            item.actor.remove_accessible_state(Atk.StateType.INDETERMINATE);
            if (state === DBusMenu.MENUITEM_TOGGLE_STATE_CHECKED) {
                if (toggleType === DBusMenu.MENUITEM_TOGGLE_CHECK)
                    ornament = PopupMenu.Ornament.CHECK;
                else if (toggleType === DBusMenu.MENUITEM_TOGGLE_RADIO)
                    ornament = PopupMenu.Ornament.DOT;

                item.actor.add_style_pseudo_class('checked');
            } else {
                item.actor.remove_style_pseudo_class('checked');
            }
            item.setOrnament(ornament);
        }
    };

    const onPropertyChanged = (_, name, value) => {
        // `value` is null when a property is cleared, so handle those cases
        // with sensible defaults.
        switch (name) {
        case DBusMenu.MENUITEM_PROP_TYPE:
            recreateItem();
            break;
        case DBusMenu.MENUITEM_PROP_ENABLED:
            item.setSensitive(value ? value.unpack() : false);
            break;
        case DBusMenu.MENUITEM_PROP_LABEL:
            item.label.text = value ? value.unpack() : '';
            break;
        case DBusMenu.MENUITEM_PROP_VISIBLE:
            item.actor.visible = value ? value.unpack() : false;
            break;
        case DBusMenu.MENUITEM_PROP_DISPOSITION:
            updateDisposition();
            break;
        case DBusMenu.MENUITEM_PROP_ACCESSIBLE_DESC:
            item.actor.get_accessible().accessible_description = value && value.unpack() || '';
            break;
        case DBusMenu.MENUITEM_PROP_ICON_DATA:
        case DBusMenu.MENUITEM_PROP_ICON_NAME:
            updateIcon();
            break;
        case DBusMenu.MENUITEM_PROP_TOGGLE_TYPE:
        case DBusMenu.MENUITEM_PROP_TOGGLE_STATE:
            updateOrnament();
            break;
        }
    };


    // Start actually building the menu item.
    const children = dbusmenuItem.get_children();
    if (children.length && !deep) {
        // Make a submenu.
        item = new PopupMenu.PopupSubMenuMenuItem(label, wantIcon);
        const updateChildren = () => {
            const itemChildren = dbusmenuItem.get_children();
            if (!itemChildren.length) {
                recreateItem();
                return;
            }

            item.menu.removeAll();
            itemChildren.forEach(remoteChild =>
                item.menu.addMenuItem(makePopupMenuItem(remoteChild, true)));
        };
        updateChildren();
        signalsHandler.add(
            [dbusmenuItem, DBusMenu.MENUITEM_SIGNAL_CHILD_ADDED, updateChildren],
            [dbusmenuItem, DBusMenu.MENUITEM_SIGNAL_CHILD_MOVED, updateChildren],
            [dbusmenuItem, DBusMenu.MENUITEM_SIGNAL_CHILD_REMOVED, updateChildren]);
    } else {
        // Don't make a submenu.
        if (!deep) {
            // We only have the potential to get a submenu if we aren't deep.
            signalsHandler.add(
                [dbusmenuItem, DBusMenu.MENUITEM_SIGNAL_CHILD_ADDED, recreateItem],
                [dbusmenuItem, DBusMenu.MENUITEM_SIGNAL_CHILD_MOVED, recreateItem],
                [dbusmenuItem, DBusMenu.MENUITEM_SIGNAL_CHILD_REMOVED, recreateItem]);
        }

        if (itemType === DBusMenu.CLIENT_TYPES_SEPARATOR) {
            item = new PopupMenu.PopupSeparatorMenuItem();
        } else if (wantIcon) {
            item = new PopupMenu.PopupImageMenuItem(label, null);
            item.icon = item._icon;
        } else {
            item = new PopupMenu.PopupMenuItem(label);
        }
    }

    // Set common initial properties.
    item.actor.visible = visible;
    item.setSensitive(enabled);
    if (accessibleDesc)
        item.actor.get_accessible().accessible_description = accessibleDesc;

    updateDisposition();
    updateIcon();
    updateOrnament();

    // Prevent an initial resize flicker.
    if (wantIcon)
        item.icon.icon_size = 16;


    signalsHandler.add(dbusmenuItem, DBusMenu.MENUITEM_SIGNAL_PROPERTY_CHANGED, onPropertyChanged);

    // Connections on item will be lost when item is disposed; there's no need
    // to add them to signalsHandler.
    item.connect('activate', () =>
        dbusmenuItem.handle_event(DBusMenu.MENUITEM_EVENT_ACTIVATED,
            new GLib.Variant('i', 0), Math.floor(Date.now() / 1000)));
    item.connect('destroy', () => signalsHandler.destroy());

    return item;
}
