
/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class Thumbnail : Gtk.Fixed {
    private class Image : Gtk.EventBox {
        public unowned Gtk.Image internal_image { get { return (Gtk.Image)get_child (); } }

        public Image (Gdk.Pixbuf pixbuf) {
            var child = new Gtk.Image.from_pixbuf (pixbuf) {
                margin = MARGIN
            };
            child.set_size_request (pixbuf.width, pixbuf.height);
            child.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            child.set_visible (true);

            add (child);
        }
    }

    public unowned Gtk.Image image { get { return _image; }  }
    private unowned Gtk.Image _image;

    public signal void clicked (Gtk.Widget source, Gdk.EventButton event);

    private const int MARGIN = 6;
    private const string CSS = """
        .copyright-label {
            color: white;
            text-shadow: 2px 2px 2px black;
        }
        .thumbnail-image {
            border-radius: 20%;
            border: 10px solid #73AD21;
        }
    """;

    public async Thumbnail.from_metadata (ImageMetadata image_metadata, ImageProvider image_provider, int ? target_width = null) throws Error {
        Object (
            can_focus: false,
            hexpand: false,
            vexpand: false,
            halign: Gtk.Align.CENTER,
            valign: Gtk.Align.CENTER
            );

        var css_provider = new Gtk.CssProvider ();
        css_provider.load_from_data (CSS, CSS.length);

        var pixbuf = yield new Gdk.Pixbuf.from_stream_async (yield image_provider.get_input_stream_async (image_metadata, ImageQuality.LOW));

        if (target_width != null) {
            var ratio = (double)target_width / pixbuf.width;
            var target_height = pixbuf.height * ratio;
            pixbuf = pixbuf.scale_simple (target_width, (int)target_height, Gdk.InterpType.BILINEAR);
        }

        var image = new Image (pixbuf);
        _image = image.internal_image;
        image.set_visible (true);

        var copyright_label = new Gtk.Label (image_metadata.copyright) {
            width_request = pixbuf.width - MARGIN * 4,
            xalign = 0
        };
        copyright_label.set_ellipsize (Pango.EllipsizeMode.END);
        copyright_label.get_style_context ().add_class ("copyright-label");
        copyright_label.get_style_context ().add_provider (css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        copyright_label.set_visible (true);

        image.button_release_event.connect ((_, event) => {
            clicked (this, event);
            return true;
        });

        put (image,           0,          0);
        put (copyright_label, MARGIN * 4, pixbuf.height - MARGIN * 4);
    }
}
