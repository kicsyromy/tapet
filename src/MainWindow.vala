/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

public class MainWindow : Hdy.ApplicationWindow {
    private static int click_counter = 0 ;

    public MainWindow () {
        TapetApplication.debug_break();
        default_height = 300 ;
        default_width = 300 ;

        var button_hello = new Gtk.Button.with_label ("Click me!") ;
        var button_hello2 = new Gtk.Button.with_label ("Click me!") ;

        var label = new Gtk.Label ("This is a label") ;

        button_hello.clicked.connect (() => {
            label.label = "The button has been clicked " + (++click_counter).to_string () + " times!" ;
        }) ;

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) ;

        var header_bar = new Hdy.HeaderBar () {
            title = "Tapet",
            show_close_button = true
        } ;

        box.add (header_bar) ;
        box.add (button_hello) ;
        box.add (button_hello2) ;
        box.add (label) ;

        add (box) ;
        show_all () ;
    }

}

