/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class BackgroundChangeHandler {
    private BasicTimer _timer = new BasicTimer ();
    private unowned GenericArray<ImageProvider> _image_providers = null;
    private uint _refresh_interval = 0;
    private const uint[] _refresh_intervals = {
        0,
        5 * 60000,
        10 * 60000,
        15 * 60000,
        30 * 60000,
        60 * 60000,
        2 * 60 * 60000,
        4 * 60 * 60000,
        6 * 60 * 60000,
        12 * 60 * 60000,
        24 * 60 * 60000
    };

    public BackgroundChangeHandler(GenericArray<ImageProvider> image_providers) {
        _image_providers = image_providers;
        _timer.fired.connect (() => {
            update_background_image.begin ((_, res) => {
                try {
                    update_background_image.end (res);
                } catch (Error e)
                {
                    TapetApplication.show_warning_dialog (Strings.CONTENT_WARN_SET_BACKGROUND_FAIL_PRIMARY, e.message + ".");
                }
            });
        });

        update_background_change_interval ();
    }

    public void update_background_change_interval () {
        var application_settings = TapetApplication.instance.application_settings;
        var refresh_interval_index = Utilities.get_interval_setting_index (application_settings.get_string (Strings.APPLICATION_SETTINGS_BACKGROUND_CHANGE_INTERVAL));
        _refresh_interval = _refresh_intervals[refresh_interval_index];
        if (_refresh_interval == 0) {
            _timer.stop ();
        } else {
            _timer.restart (_refresh_interval);
        }
    }

    private async void update_background_image () throws Error {
        ImageMetadata image_metadata = null;
        ImageProvider image_provider = null;
        foreach (var provider in _image_providers.data)
        {
            var im = yield provider.get_latest_image_metadata ();
            if (image_metadata == null || image_metadata.date_time.to_unix () < im.date_time.to_unix ()) {
                image_metadata = im;
                image_provider = provider;
            }
        }

        yield Utilities.set_background_image (image_metadata, image_provider);
    }
}
