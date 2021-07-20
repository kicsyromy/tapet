/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class Strings {
    /* Application */
    public const string APPLICATION_ID = "com.github.kicsyromy.tapet" ;
    public const string APPLICATION_NAME = _ ("Tapet") ;
    public const string APPLICATION_ERROR_QUARK = APPLICATION_ID ;

    public const string APPLICATION_ERROR_INIT_FAILED = _ ("Tapet failed to initialize properly") ;
    public const string APPLICATION_ERROR_CACHE_CREATE = _ ("Failed to create cache directory") ;

    /* Header Bar */
    public const string HEADER_BAR_MENU_TOOLTIP = _ ("Menu") ;

    /* Menu Items */
    public const string MENU_ITEM_SETTINGS = _ ("Settings...") ;
    public const string MENU_ITEM_ABOUT = _ ("About Tapet") ;

    /* Settings Dialog */
    public const string SETTINGS_DOWNLOAD_FOLDER = _ ("Download folder") ;

    /* Main Content */
    public const string CONTENT_POPOVER_SET_BACKGROUND = _ ("Set as wallpaper") ;
    public const string CONTENT_POPOVER_SAVE_AS = _ ("Save as...") ;

    public const string CONTENT_WARN_SET_BACKGROUND_FAIL_PRIMARY = _ ("Failed to set wallpaper") ;

    /* Miscellaneous */
    public const string MISC_OPEN = _ ("Open") ;
    public const string MISC_CLOSE = _ ("Close") ;
    public const string MISC_CANCEL = _ ("Cancel") ;
    public const string MISC_QUIT = _ ("Quit") ;

    public const string MISC_BACKGROUND_SCHEMA = "org.gnome.desktop.background" ;
    public const string MISC_BACKGROUND_PICTURE_URI_KEY = "/org/gnome/desktop/background/picture-uri" ;
    public const string MISC_BACKGROUND_PICTURE_OPTIONS = "/org/gnome/desktop/background/picture-options" ;
}