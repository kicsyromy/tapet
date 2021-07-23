/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class Utilities {
    public static int get_interval_setting_index (string value) {
        return int.parse (value.split ("|", 1)[0]);
    }
    public static string get_interval_setting_value (string value) {
        return value.split ("|", 2)[1];
    }

    public static async string download_async (string url, OutputStream output_stream) throws Error {
        string content_type = null;
        var in_stream = yield get_stream_async (url, out content_type);

        yield output_stream.splice_async (in_stream, OutputStreamSpliceFlags.CLOSE_SOURCE);

        return content_type;
    }

    public static async InputStream get_stream_async (string url, out string content_type = null) throws Error {
        var session = new Soup.Session ();
        var msg = new Soup.Message ("GET", url);

        var in_stream = yield session.send_async (msg, null);

        if (msg.status_code != 200) {
            throw new Error (TapetError.quark, TapetError.Code.SERVER_BAD_RESPONSE, "%s: %u %s", Strings.ERROR_MESSAGE_BAD_RESPONSE, msg.status_code, msg.reason_phrase);
        }

        content_type = msg.response_headers.get_content_type (null);
        return in_stream;
    }

    public static async void set_background_image (ImageMetadata image_metadata, ImageProvider image_provider) throws Error {
        var system_settings = TapetApplication.instance.system_settings;
        var application_settings = TapetApplication.instance.application_settings;

        var current_background = system_settings.get_value (Strings.MISC_BACKGROUND_PICTURE_URI_KEY).get_string (null);
        var file_name = yield image_provider.save_to_file_async (image_metadata, ImageQuality.HIGH, TapetApplication.instance.cache_dir, "wp_", false);
        var new_background = "file://" + file_name;

        if (current_background != new_background) {
            system_settings.set_value (Strings.MISC_BACKGROUND_PICTURE_URI_KEY, new_background);
            system_settings.set_value (Strings.MISC_BACKGROUND_PICTURE_OPTIONS, "zoom");
            system_settings.flush ();

            var show_notification = application_settings.get_boolean (Strings.APPLICATION_SETTINGS_ENABLE_NOTIFICATIONS);
            if (show_notification) {
                var notification = new Notification (Strings.NOTIFICATION_BACKGROUND_SET_TITLE);
                notification.set_body (Strings.NOTIFICATION_BACKGROUND_SET_MESSAGE.printf (image_metadata.title));
                TapetApplication.instance.send_notification (Strings.APPLICATION_ID, notification);
            }
        }
    }
}