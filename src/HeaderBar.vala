/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

public class HeaderBar : Hdy.HeaderBar {
    public HeaderBar () {
        Object (show_close_button: true, title: "Tapet") ;
    }

    construct {
        var settings_menuitem = new Gtk.ModelButton () ;
        settings_menuitem.text = _ ("Settings…") ;

        var about_menuitem = new Gtk.ModelButton () ;
        about_menuitem.text = _ ("About Tapet") ;

        var app_menu_grid = new Gtk.Grid () {
            margin_bottom = 3,
            margin_top = 3,
            orientation = Gtk.Orientation.VERTICAL
        } ;
        app_menu_grid.add (settings_menuitem) ;
        app_menu_grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_bottom = 3,
            margin_top = 3
        }) ;
        app_menu_grid.add (about_menuitem) ;
        app_menu_grid.show_all () ;

        var app_menu_popover = new Gtk.Popover (null) ;
        app_menu_popover.add (app_menu_grid) ;

        var app_menu = new Gtk.MenuButton () {
            image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR),
            popover = app_menu_popover,
            tooltip_text = _ ("Menu")
        } ;

        pack_end (app_menu) ;

        settings_menuitem.clicked.connect (() => {
            (new SettingsDialog (MainWindow.instance)).show_all () ;
        }) ;
    }

}
