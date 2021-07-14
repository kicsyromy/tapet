/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

public class SettingsDialog : Granite.Dialog {
    public SettingsDialog (Gtk.Window parent) {
        transient_for = parent ;
        // var header = new Granite.HeaderLabel ("Header");
        // var entry = new Gtk.Entry ();
        // var gtk_switch = new Gtk.Switch () {
        // halign = Gtk.Align.START
        // };


        // var dialog = new Granite.Dialog () {
        // transient_for = window
        // };

        // var suggested_button = dialog.add_button ("Suggested Action", Gtk.ResponseType.ACCEPT);
        // suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        // dialog.show_all ();
        // dialog.response.connect ((response_id) => {
        // if (response_id == Gtk.ResponseType.ACCEPT) {
        // toast.send_notification ();
        // }

        // dialog.destroy ();
        // });
    }

    construct {
        modal = true ;

        var download_folder_text = _ ("Download folder") ;

        var path = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            valign = Gtk.Align.FILL
        } ;
        var path_label = new Gtk.Label (download_folder_text) {
            margin_right = 100,
            halign = Gtk.Align.START
        } ;
        var path_button = new Gtk.Button.with_label (_ ("C:\\")) {
            halign = Gtk.Align.FILL
        } ;
        path.pack_start (path_label, false, false) ;
        path.pack_end (path_button, true, true) ;

        var download_options = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) ;
        unowned Gtk.StyleContext download_options_ctx = download_options.get_style_context () ;
        download_options_ctx.add_class (Granite.STYLE_CLASS_CARD) ;
        download_options_ctx.add_class (Granite.STYLE_CLASS_ROUNDED) ;
        download_options.add (path) ;

        var layout = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin = 12,
            margin_top = 0,
            valign = Gtk.Align.FILL
        } ;
        layout.add (download_options) ;
        // layout.attach (entry, 0, 2);
        // layout.attach (gtk_switch, 0, 3);

        get_content_area ().add (layout) ;

        var ok_button = (Gtk.Button)add_button (_ ("OK"), Gtk.ResponseType.ACCEPT) ;
        ok_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION) ;

        path_button.clicked.connect (() => {
            var location_chooser = new Gtk.FileChooserDialog (download_folder_text, this, Gtk.FileChooserAction.SELECT_FOLDER, _ ("Open"), Gtk.ResponseType.ACCEPT, _ ("Cancel"), Gtk.ResponseType.CANCEL) ;
            location_chooser.show_all () ;
        }) ;

        ok_button.clicked.connect (() => {
            destroy () ;
        }) ;
    }

}

