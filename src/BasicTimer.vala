/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class BasicTimer {
    private TimeoutSource _timeout_source = null;
    private MainContext _main_context = null;

    public bool running { get { return _timeout_source != null;} }

    public BasicTimer() {
        _main_context = MainContext.default ();
    }

    public void start (uint interval_ms) {
        if (_timeout_source != null) {
            return;
        }

        _timeout_source = new TimeoutSource (interval_ms);
        _timeout_source.set_callback (() => {
            fired ();
            return true;
        });
        _timeout_source.attach (_main_context);
    }

    public void stop () {
        if (_timeout_source != null) {
            _timeout_source.destroy ();
            _timeout_source = null;
        }
    }

    public void restart (uint interval_ms) {
        stop ();
        start (interval_ms);
    }


    public signal void fired ();
}