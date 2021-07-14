/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

public class MainWindow : Hdy.ApplicationWindow {
    internal static MainWindow instance = null ;

    public MainWindow () {
        delete_event.connect (hide_on_delete) ;
        instance = this ;
    }

    construct {
        default_width = 600 ;
        default_height = 800 ;
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) ;

        box.add (new HeaderBar ()) ;

        add (box) ;
        show_all () ;
    }

}

