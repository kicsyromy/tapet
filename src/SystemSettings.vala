/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class SystemSettings {
    [CCode (cname = "dconf_client_sync")]
    private static extern void dconf_client_sync(DConf.Client client) ;

    private DConf.Client dconf_client = new DConf.Client () ;

    public Variant get_value(string key) {
        return dconf_client.read (key) ;
    }

    public void set_value(string key, Variant value) throws Error {
        dconf_client.write_fast (key, value) ;
    }

    public void flush() {
        dconf_client_sync (dconf_client) ;
    }

}