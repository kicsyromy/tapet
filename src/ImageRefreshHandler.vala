/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class ImageRefreshHandler {
    private BasicTimer _timer = new BasicTimer ();
    private unowned GenericArray<ImageProvider> _image_providers = null;
    private uint _refresh_interval = 0;
    private const uint[] _refresh_intervals = {
        0,
        60000,
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

    public ImageRefreshHandler(GenericArray<ImageProvider> image_providers) {
        _image_providers = image_providers;
        _timer.fired.connect (() => {
            foreach (var image_provider in _image_providers.data)
            {
                MainWindow.instance.refresh_content_from_provider (image_provider);
            }
        });

        update_refresh_interval ();
    }

    public void update_refresh_interval () {
        var application_settings = TapetApplication.instance.application_settings;
        var refresh_interval_index = Utilities.get_interval_setting_index (application_settings.get_string (Strings.APPLICATION_SETTINGS_REFRESH_INTERVAL));
        _refresh_interval = _refresh_intervals[refresh_interval_index];
        if (_refresh_interval == 0) {
            _timer.stop ();
        } else {
            _timer.restart (_refresh_interval);
        }
    }
}