/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class Content : Gtk.ScrolledWindow {
    private class ImageSource {
        public ImageMetadata metadata;
        public unowned ImageProvider image_provider;
    }

    private Gtk.Popover _right_click_menu = new Gtk.Popover (null);

    private HashTable<unowned Gtk.Widget, ImageSource> _thumbnails = new HashTable<unowned Gtk.Widget, ImageSource>(direct_hash, direct_equal);
    private HashTable<unowned ImageProvider, unowned Gtk.FlowBox> _thumbnail_containers = new HashTable<unowned ImageProvider, unowned Gtk.FlowBox>(direct_hash, direct_equal);

    construct {
        var set_background_menuitem = new Gtk.ModelButton ();
        set_background_menuitem.text = Strings.CONTENT_POPOVER_SET_BACKGROUND;

        var save_as_menuitem = new Gtk.ModelButton ();
        save_as_menuitem.text = Strings.CONTENT_POPOVER_SAVE_AS;

        var right_click_menu_grid = new Gtk.Grid () {
            margin_bottom = 3,
            margin_top = 3,
            orientation = Gtk.Orientation.VERTICAL
        };

        right_click_menu_grid.add (set_background_menuitem);
        right_click_menu_grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_bottom = 3,
            margin_top = 3
        });
        right_click_menu_grid.add (save_as_menuitem);
        right_click_menu_grid.show_all ();

        _right_click_menu.add (right_click_menu_grid);
        _right_click_menu.set_position (Gtk.PositionType.BOTTOM);

        foreach (var image_provider in TapetApplication.instance.image_providers.data) {
            var flow_box = new Gtk.FlowBox () {
                vexpand = true,
                hexpand = true,
                halign = Gtk.Align.FILL,
                valign = Gtk.Align.START,
                homogeneous = true
            };
            _thumbnail_containers.insert (image_provider, flow_box);

            refresh_content_from_provider (image_provider);

            add (flow_box);
        }

        show_all ();

        set_background_menuitem.clicked.connect (() => {
            var thumbnail_source = _thumbnails.get (_right_click_menu.get_relative_to ());
            Utilities.set_background_image.begin (thumbnail_source.metadata, thumbnail_source.image_provider, (_, res) => {
                try {
                    Utilities.set_background_image.end (res);
                } catch (Error error) {
                    TapetApplication.show_warning_dialog (Strings.CONTENT_WARN_SET_BACKGROUND_FAIL_PRIMARY, error.message + ".");
                }
            });
        });

        save_as_menuitem.clicked.connect (() => {
            var thumbnail = (Gtk.Image)_right_click_menu.get_relative_to ();
            var image_source = _thumbnails.get (thumbnail);

            save_image.begin (thumbnail, image_source, (_, res) => {
                try {
                    save_image.end (res);
                } catch (Error error) {
                    TapetApplication.show_warning_dialog (Strings.CONTENT_WARN_SAVE_BACKGROUND_FAIL_PRIMARY, error.message + ".");
                }
            });
        });
    }

    public void refresh_content_from_provider (ImageProvider image_provider) {
        var container = _thumbnail_containers.get (image_provider);
        container.foreach ((child) => {
            container.remove (child);
        });

        /* TODO: Take scaling into account somehow */
        load_thumbnails.begin (image_provider, container, 500, (_, res) => {
            load_thumbnails.end (res);
        });
    }

    private void on_image_clicked (Gtk.Widget image, Gdk.EventButton event) {
        var mouse_button = event.button;
        if (mouse_button == 3) {
            _right_click_menu.set_relative_to (image);
            _right_click_menu.set_pointing_to (Gdk.Rectangle () {
                x = (int)Math.round (event.x), y = (int)Math.round (event.y),
                width = 1, height = 1
            });
            _right_click_menu.set_visible (true);
        }
    }

    private async void save_image (Gtk.Image thumbnail, ImageSource image_source) throws Error {
        var file_chooser = new Gtk.FileChooserNative (Strings.CONTENT_POPOVER_SAVE_AS, null, Gtk.FileChooserAction.SAVE, Strings.MISC_SAVE, Strings.MISC_CANCEL);

        var filter = new Gtk.FileFilter ();
        var filter_text = Strings.MISC_IMAGE_FILTER_NAME;
        filter.set_filter_name (filter_text + "(" + image_source.metadata.extension + ")");
        filter.add_mime_type (image_source.metadata.mime_type);

        file_chooser.add_filter (filter);
        file_chooser.set_current_name (image_source.metadata.title + image_source.metadata.extension);

        var result = file_chooser.run ();
        if (result == Gtk.ResponseType.ACCEPT) {
            MainWindow.instance.set_sensitive (false);
            var file = file_chooser.get_file ();

            try {
                FileOutputStream output_stream = null;
                try {
                    output_stream = yield file.create_async (GLib.FileCreateFlags.NONE);
                } catch (IOError error) {
                    if (error.code == IOError.EXISTS) {
                        yield file.delete_async ();

                        output_stream = yield file.create_async (GLib.FileCreateFlags.NONE);
                    } else {
                        throw error;
                    }
                }

                yield image_source.image_provider.save_to_stream_async (image_source.metadata, ImageQuality.HIGH, output_stream);
                yield output_stream.close_async ();
            } catch (Error error) {
                throw error;
            } finally {
                MainWindow.instance.set_sensitive (true);
            }
        }
    }

    private async void load_thumbnails (ImageProvider image_provider, Gtk.Container container, int target_width) {
        try {
            var metadatas = yield image_provider.get_image_metadata_async (image_provider.get_max_image_count ());

            foreach (var metadata in metadatas) {
                try {
                    var pixbuf = yield new Gdk.Pixbuf.from_stream_async (yield image_provider.get_input_stream_async (metadata, ImageQuality.LOW));

                    var ratio = (double)target_width / pixbuf.width;
                    var target_height = pixbuf.height * ratio;

                    var image = new Gtk.Image.from_pixbuf (pixbuf.scale_simple (target_width, (int)target_height, Gdk.InterpType.BILINEAR));
                    var image_style_ctx = image.get_style_context ();
                    image_style_ctx.add_class (Granite.STYLE_CLASS_CARD);
                    image.set_visible (true);

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

                    container.add (event_box);
                    _thumbnails.insert (image, new ImageSource () {
                        metadata = metadata,
                        image_provider = image_provider
                    });

                    event_box.button_release_event.connect ((_, event) => {
                        on_image_clicked (image, event);
                        return true;
                    });
                } catch (Error error) {
                    warning ("%s %s: '%s': %d: %s\n", Strings.WARN_DOWNLOAD_IMAGE, metadata.id, image_provider.name (), error.code, error.message);
                }
            }
        } catch (Error error) {
            warning ("%s %s: %d: %s\n", Strings.WARN_DOWNLOAD_IMAGES, image_provider.name (), error.code, error.message);
        }
    }
}