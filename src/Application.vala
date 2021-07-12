/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

public class TapetApplication : Gtk.Application {
    public extern static void debug_break() ;

    public TapetApplication () {
        Object (
            application_id: "com.github.kicsyromy.tapet",
            flags : ApplicationFlags.FLAGS_NONE
            ) ;
    }

    protected override void activate() {
        add_window (new MainWindow()) ;
    }

    public static int main(string[] args) {
        var app = new TapetApplication () ;
        app.startup.connect (() => {
            Hdy.init () ;
        }) ;
        return app.run (args) ;
    }
}

