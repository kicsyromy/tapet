/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class Content : Gtk.ScrolledWindow {

    private Gtk.Popover right_click_menu = new Gtk.Popover (null) ;

    private HashTable<unowned Gtk.Widget, string> images = new HashTable<unowned Gtk.Widget, string>(direct_hash, direct_equal) ;

    public Content () {
    }

    construct {
        var set_background_menuitem = new Gtk.ModelButton () ;
        set_background_menuitem.text = Strings.CONTENT_POPOVER_SET_BACKGROUND ;

        var save_as_menuitem = new Gtk.ModelButton () ;
        save_as_menuitem.text = Strings.CONTENT_POPOVER_SAVE_AS ;

        var right_click_menu_grid = new Gtk.Grid () {
            margin_bottom = 3,
            margin_top = 3,
            orientation = Gtk.Orientation.VERTICAL
        } ;

        right_click_menu_grid.add (set_background_menuitem) ;
        right_click_menu_grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_bottom = 3,
            margin_top = 3
        }) ;
        right_click_menu_grid.add (save_as_menuitem) ;
        right_click_menu_grid.show_all () ;

        right_click_menu.add (right_click_menu_grid) ;
        right_click_menu.set_position (Gtk.PositionType.BOTTOM) ;

        var flow_box = new Gtk.FlowBox () {
            vexpand = true,
            hexpand = true,
            halign = Gtk.Align.FILL,
            valign = Gtk.Align.START,
            homogeneous = true
        } ;

        add (flow_box) ;

        show_all () ;

        /* TODO: Take scaling into account somehow */
        load_thumbnails.begin (flow_box, 600, (_, res) => {
            load_thumbnails.end (res) ;
        }) ;
    }

    private void on_image_clicked(Gtk.Widget image, Gdk.EventButton event) {
        var mouse_button = event.button ;
        if( mouse_button == 3 ){
            right_click_menu.set_relative_to (image) ;
            right_click_menu.set_pointing_to (Gdk.Rectangle () {
                x = (int) Math.round (event.x), y = (int) Math.round (event.y), width = 1, height = 1
            }) ;
            right_click_menu.set_visible (true) ;
        }
    }

    private async void load_thumbnails(Gtk.Container container, int target_width) {
        var image_providers = TapetApplication.instance.image_providers.data ;

        foreach( var image_provider in image_providers ){
            try {
                var ids = yield image_provider.get_image_ids(image_provider.get_max_image_count ()) ;

                foreach( var id in ids ){
                    var url = yield image_provider.get_image_url(id, ImageQuality.LOW) ;

                    var pixbuf = yield new Gdk.Pixbuf.from_stream_async (yield Utilities.get_stream_async (url)) ;

                    var ratio = (double) target_width / pixbuf.width ;
                    var target_height = pixbuf.height * ratio ;

                    var image = new Gtk.Image.from_pixbuf (pixbuf.scale_simple (target_width, (int) target_height, Gdk.InterpType.BILINEAR)) ;
                    var image_style_ctx = image.get_style_context () ;
                    image_style_ctx.add_class (Granite.STYLE_CLASS_CARD) ;
                    image_style_ctx.add_class (Granite.STYLE_CLASS_ROUNDED) ;
                    image.set_visible (true) ;

                    var event_box = new Gtk.EventBox () {
                        can_focus = false,
                        margin = 12,
                        margin_bottom = 0,
                        hexpand = false,
                        vexpand = false,
                        halign = Gtk.Align.CENTER,
                        valign = Gtk.Align.CENTER
                    } ;
                    event_box.add (image) ;
                    event_box.set_visible (true) ;

                    container.add (event_box) ;
                    images.insert (image, id) ;

                    event_box.button_release_event.connect ((_, event) => {
                        on_image_clicked (image, event) ;
                        return true ;
                    }) ;
                }
            } catch ( Error error ) {
                printerr ("Failed to download images from provider '%s': %d: %s\n", image_provider.name (), error.code, error.message) ;
            }

        }
    }

}