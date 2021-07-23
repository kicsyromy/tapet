/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class SettingsDialog : Granite.Dialog {
    private static string[] _background_change_interval_combobox_values = {
        Strings.SETTINGS_COMBO_BOX_INTERVAL_NEVER,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_5_MINUTES,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_10_MINUTES,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_15_MINUTES,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_30_MINUTES,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_1_HOUR,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_2_HOURS,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_4_HOURS,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_6_HOURS,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_12_HOURS,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_1_DAY
    };

    private static string[] _refresh_interval_combobox_values = {
        Strings.SETTINGS_COMBO_BOX_INTERVAL_NEVER,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_1_MINUTE,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_5_MINUTES,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_10_MINUTES,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_15_MINUTES,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_30_MINUTES,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_1_HOUR,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_2_HOURS,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_4_HOURS,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_6_HOURS,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_12_HOURS,
        Strings.SETTINGS_COMBO_BOX_INTERVAL_1_DAY
    };

    public SettingsDialog (Gtk.Window parent) {
        transient_for = parent;
    }

    construct {
        var application_settings = TapetApplication.instance.application_settings;
        var section_general_settings = create_settings_section (Strings.SETTINGS_LABEL_SECTION_GENERAL_SETTINGS);

        var background_change_interval_combo_box = new Gtk.ComboBoxText ();
        foreach (var value in _background_change_interval_combobox_values)
        {
            background_change_interval_combo_box.append_text (value);
        }
        application_settings.bind_with_mapping (
            Strings.APPLICATION_SETTINGS_BACKGROUND_CHANGE_INTERVAL,
            background_change_interval_combo_box,
            "active",
            GLib.SettingsBindFlags.DEFAULT,
            (value, variant, _) => {
            value.set_int (Utilities.get_interval_setting_index (variant.get_string (null)));
            return true;
        },
            (value, _, __) => {
            var v = value.get_int ();
            string choice_value;
            if (v == 0) {
                choice_value = Utilities.get_interval_setting_value (Strings.APPLICATION_SETTINGS_INTERVAL_CHOICES_ALL[v]);
            } else {
                choice_value = Utilities.get_interval_setting_value (Strings.APPLICATION_SETTINGS_INTERVAL_CHOICES_ALL[v + 1]);
            }
            return new Variant.string (v.to_string () + "|" + choice_value);
        },
            null, null);
        var background_change_interval = create_settings_item (Strings.SETTINGS_LABEL_ITEM_BACKGROUND_CHANGE_INTERVAL, background_change_interval_combo_box);
        section_general_settings.add (background_change_interval);

        var startup_switch = new Gtk.Switch ();
        application_settings.bind (Strings.APPLICATION_SETTINGS_STARTUP_SET_LATEST, startup_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        var startup_set_latest = create_settings_item (Strings.SETTINGS_LABEL_ITEM_STARTUP_SET_LATEST, startup_switch);
        section_general_settings.add (startup_set_latest);

        var dont_reuse_wallpapers_switch = new Gtk.Switch ();
        application_settings.bind (Strings.APPLICATION_SETTINGS_DONT_REUSE_OLD_WALLPAPERS, dont_reuse_wallpapers_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        var dont_reuse_wallpapers = create_settings_item (Strings.SETTINGS_LABEL_ITEM_DONT_REUSE_OLD_WALLPAPERS, dont_reuse_wallpapers_switch);
        section_general_settings.add (dont_reuse_wallpapers);

        var refresh_interval_combo_box = new Gtk.ComboBoxText ();
        foreach (var s in _refresh_interval_combobox_values)
        {
            refresh_interval_combo_box.append_text (s);
        }
        application_settings.bind_with_mapping (
            Strings.APPLICATION_SETTINGS_REFRESH_INTERVAL,
            refresh_interval_combo_box,
            "active",
            GLib.SettingsBindFlags.DEFAULT,
            (value, variant, _) => {
            value.set_int (Utilities.get_interval_setting_index (variant.get_string (null)));
            return true;
        },
            (value, _, __) => {
            var v = value.get_int ();
            return new Variant.string (Strings.APPLICATION_SETTINGS_INTERVAL_CHOICES_ALL[v]);
        },
            null, null);

        var refresh_images = create_settings_item (Strings.SETTINGS_LABEL_ITEM_REFRESH_INTERVAL, refresh_interval_combo_box);
        section_general_settings.add (refresh_images);

        var notifications_switch = new Gtk.Switch ();
        application_settings.bind (Strings.APPLICATION_SETTINGS_ENABLE_NOTIFICATIONS, notifications_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        var notifications = create_settings_item (Strings.SETTINGS_LABEL_ITEM_ENABLE_NOTIFICATIONS, notifications_switch);
        section_general_settings.add (notifications);

        var section_application_settings = create_settings_section (Strings.SETTINGS_LABEL_SECTION_APPLICATION_SETTINGS);

        var keep_running_switch = new Gtk.Switch ();
        application_settings.bind (Strings.APPLICATION_SETTINGS_KEEP_RUNNING_WHEN_CLOSED, keep_running_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        var keep_running = create_settings_item (Strings.SETTINGS_LABEL_ITEM_KEEP_RUNNING_WHEN_CLOSED, keep_running_switch);
        section_application_settings.add (keep_running);

        var layout = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin = 12,
            margin_top = 0
        };
        layout.add (section_general_settings);
        layout.add (section_application_settings);

        add_button (Strings.MISC_CLOSE, Gtk.ResponseType.OK)
            .get_style_context ()
            .add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var content_area = get_content_area ();
        content_area.vexpand = true;
        content_area.pack_start (layout);

        response.connect ((response_id) => {
            destroy ();
        });
    }

    private static Gtk.Box create_settings_section (string section_name) {
        var section = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin = 6,
            vexpand = true
        };
        var section_context = section.get_style_context ();
        section_context.add_class (Granite.STYLE_CLASS_CARD);
        section_context.add_class (Granite.STYLE_CLASS_ROUNDED);

        var label = new Gtk.Label (section_name) {
            halign = Gtk.Align.START,
            margin = 6,
            margin_left = 12,
            margin_bottom = 0
        };

        label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
        section.add (label);

        return section;
    }

    private static Gtk.Box create_settings_item (string label_text, Gtk.Widget ? widget = null) {
        var container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            margin_top = 0,
            margin_bottom = 12,
            margin_left = 24,
            margin_right = 24,
            vexpand = true
        };

        var label = new Gtk.Label (label_text) {
            margin_right = 32,
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };

        container.pack_start (label, false, false);

        if (widget != null) {
            widget.halign = Gtk.Align.END;
            widget.valign = Gtk.Align.CENTER;
            container.pack_end (widget, false, false);
        }

        return container;
    }
}

