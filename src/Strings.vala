/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class Strings {
    /* Application */
    public const string APPLICATION_ID = "com.github.kicsyromy.tapet";
    public const string APPLICATION_NAME = _ ("Tapet");
    public const string APPLICATION_ERROR_QUARK = APPLICATION_ID;

    public const string APPLICATION_ERROR_INIT_FAILED = _ ("Tapet failed to initialize properly");
    public const string APPLICATION_ERROR_CACHE_CREATE = _ ("Failed to create cache directory");

    /* Header Bar */
    public const string HEADER_BAR_MENU_TOOLTIP = _ ("Menu");

    /* Menu Items */
    public const string MENU_ITEM_SETTINGS = _ ("Settings...");
    public const string MENU_ITEM_ABOUT = _ ("About Tapet");

    /* Settings Dialog */
    public const string SETTINGS_LABEL_SECTION_GENERAL_SETTINGS = _ ("General settings");
    public const string SETTINGS_LABEL_ITEM_BACKGROUND_CHANGE_INTERVAL = _ ("Try to change the wallpaper automatically at an interval");
    public const string SETTINGS_LABEL_ITEM_DONT_REUSE_OLD_WALLPAPERS = _ ("Don't set any previously set wallpapers");
    public const string SETTINGS_LABEL_ITEM_REFRESH_IMAGE_LIST = _ ("Refresh the list of available wallpapers");
    public const string SETTINGS_LABEL_ITEM_STARTUP_SET_LATEST = _ ("When starting set the most recent image available as wallpaper");
    public const string SETTINGS_LABEL_ITEM_ENABLE_NOTIFICATIONS = _ ("Display a notification when changing wallpaper");

    public const string SETTINGS_LABEL_SECTION_APPLICATION_SETTINGS = _ ("Application settings");
    public const string SETTINGS_LABEL_ITEM_KEEP_RUNNING_WHEN_CLOSED = _ ("Keep Tapet running in the background when closed");

    /* Main Content */
    public const string CONTENT_POPOVER_SET_BACKGROUND = _ ("Set as wallpaper");
    public const string CONTENT_POPOVER_SAVE_AS = _ ("Save as...");

    public const string CONTENT_WARN_SET_BACKGROUND_FAIL_PRIMARY = _ ("Failed to set wallpaper");
    public const string CONTENT_WARN_SAVE_BACKGROUND_FAIL_PRIMARY = _ ("Failed to save wallpaper");

    public const string DEBUG_APPLY_WALLPAPER = _ ("Applying wallpaper");

    public const string WARN_DOWNLOAD_IMAGE = _ ("Failed to download image from provider");
    public const string WARN_DOWNLOAD_IMAGES = _ ("Failed to download images from provider");

    /* Miscellaneous */
    public const string MISC_OPEN = _ ("_Open");
    public const string MISC_SAVE = _ ("_Save");
    public const string MISC_CLOSE = _ ("_Close");
    public const string MISC_CANCEL = _ ("_Cancel");
    public const string MISC_QUIT = _ ("_Quit");

    public const string MISC_IMAGE_FILTER_NAME = _ ("Image");

    public const string MISC_BACKGROUND_SCHEMA = "org.gnome.desktop.background";
    public const string MISC_BACKGROUND_PICTURE_URI_KEY = "/org/gnome/desktop/background/picture-uri";
    public const string MISC_BACKGROUND_PICTURE_OPTIONS = "/org/gnome/desktop/background/picture-options";

    public const string ERROR_MESSAGE_BAD_RESPONSE = _ ("Download failed, server responded with");
}
