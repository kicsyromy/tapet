/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

public class MyApp : Gtk.Application {
    private extern static void debug_break() ;

    private static int click_counter = 0 ;

    public MyApp () {
        Object (
            application_id: "com.github.kicsyromy.tapet",
            flags : ApplicationFlags.FLAGS_NONE
            ) ;
    }

    protected override void activate() {
        var button_hello = new Gtk.Button.with_label ("Click me!") {
            margin = 12
        } ;

        var label = new Gtk.Label ("This is a label") ;

        button_hello.clicked.connect (() => {
            label.label = "The button has been clicked " + (++click_counter).to_string () + " times!" ;
        }) ;

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2) ;
        box.add (button_hello) ;
        box.add (label) ;

        var main_window = new Gtk.ApplicationWindow (this) {
            default_height = 300,
            default_width = 300,
            title = "Tapet"
        } ;

        main_window.add (box) ;
        main_window.show_all () ;
    }

    public static int main(string[] args) {
        // debug_break () ;
        return new MyApp ().run (args) ;
    }

}

