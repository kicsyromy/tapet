/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class Content : Gtk.ScrolledWindow {
    public Content () {
    }

    construct {
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

    private static async void load_thumbnails(Gtk.Container container, int target_width) {
        var image_providers = TapetApplication.instance.image_providers.data ;

        foreach( var image_provider in image_providers ){
            try {
                var urls = yield image_provider.get_image_urls(image_provider.max_image_count (), ImageQuality.LOW) ;

                foreach( var url in urls ){
                    var pixbuf = yield new Gdk.Pixbuf.from_stream_async (yield Utilities.get_stream_async (url)) ;

                    var ratio = (double) target_width / pixbuf.width ;
                    var target_height = pixbuf.height * ratio ;

                    var image = new Gtk.Image.from_pixbuf (pixbuf.scale_simple (target_width, (int) target_height, Gdk.InterpType.BILINEAR)) {
                        margin = 12,
                        margin_bottom = 0,
                        hexpand = false,
                        vexpand = false,
                        halign = Gtk.Align.CENTER,
                        valign = Gtk.Align.CENTER
                    } ;
                    var image_style_ctx = image.get_style_context () ;
                    image_style_ctx.add_class (Granite.STYLE_CLASS_CARD) ;
                    image_style_ctx.add_class (Granite.STYLE_CLASS_ROUNDED) ;
                    image.set_visible (true) ;

                    container.add (image) ;
                }
            } catch ( Error error ) {
                printerr ("Failed to download images from provider '%s': %d: %s\n", image_provider.name (), error.code, error.message) ;
            }

        }
    }

}