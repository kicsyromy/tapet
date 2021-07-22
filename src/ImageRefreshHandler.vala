/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class ImageRefreshHandler {
    private BasicTimer _timer = new BasicTimer ();
    private unowned GenericArray<ImageProvider> _image_providers = null;
    private uint _refresh_interval = 0;

    public ImageRefreshHandler(GenericArray<ImageProvider> image_providers) {
        _image_providers = image_providers;
        _timer.fired.connect (() => {
            print ("Refresh now!!\n");
        });
    }

    public void start () {
        _timer.restart (_refresh_interval);
    }

    public void stop () {
        _timer.stop ();
    }

    public void set_interval (uint interval_ms) {
        _refresh_interval = interval_ms;
        if (_timer.running) {
            start ();
        }
    }
}