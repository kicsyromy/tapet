
/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class Thumbnail : Gtk.Fixed {
    public unowned Gtk.Image image { get { return _image; }  }

    public signal void clicked (Gtk.Widget source, Gdk.EventButton event);

    public async Thumbnail.from_metadata (ImageMetadata image_metadata, ImageProvider image_provider, int ? target_width = null) throws Error {
        var pixbuf = yield new Gdk.Pixbuf.from_stream_async (yield image_provider.get_input_stream_async (image_metadata, ImageQuality.LOW));

        if (target_width != null) {
            var ratio = (double)target_width / pixbuf.width;
            var target_height = pixbuf.height * ratio;
            pixbuf = pixbuf.scale_simple (target_width, (int)target_height, Gdk.InterpType.BILINEAR);
        }
        var image = new Gtk.Image.from_pixbuf (pixbuf);

        var image_style_ctx = image.get_style_context ();
        image_style_ctx.add_class (Granite.STYLE_CLASS_CARD);
        image.set_visible (true);
        _image = image;

        var copyright_label = new Gtk.Label (image_metadata.copyright) {
            width_request = pixbuf.width,
            xalign = 0
        };
        copyright_label.set_ellipsize (Pango.EllipsizeMode.END);
        var css = CSS;
        var css_provider = new Gtk.CssProvider ();
        css_provider.load_from_data (css, css.length);
        copyright_label.get_style_context ().add_class ("copyright-label");
        copyright_label.get_style_context ().add_provider (css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        copyright_label.set_visible (true);

        var event_box = new Gtk.EventBox () {
            can_focus = false,
            margin = 6,
            hexpand = false,
            vexpand = false,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER
        };

        event_box.add (image);
        event_box.set_visible (true);

        event_box.button_release_event.connect ((_, event) => {
            event.x += 6;
            event.y += 6;
            clicked (this, event);
            return true;
        });

        put (event_box,       0,  0);
        put (copyright_label, 10, pixbuf.height - 15);
    }

    private const string CSS = """
        .copyright-label {
            color: white;
            text-shadow: 2px 2px 2px black;
        }
    """;

    private unowned Gtk.Image _image;
}
