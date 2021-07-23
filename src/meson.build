cc = meson.get_compiler('c')

sources = [
    'providers' / 'BingImageProvider.vala',
    'providers' / 'ImageProvider.vala',
    'Application.vala',
    'BackgroundChangeHandler.vala',
    'BasicTimer.vala',
    'Content.vala',
    'Error.vala',
    'HeaderBar.vala',
    'ImageRefreshHandler.vala',
    'MainWindow.vala',
    'SettingsDialog.vala',
    'Strings.vala',
    'SystemSettings.vala',
    'Utilities.vala',
]

dependencies = [
    dependency('gtk+-3.0'),
    dependency('granite'),
    dependency('libhandy-1'),
    dependency('libsoup-2.4'),
    dependency('json-glib-1.0'),
    dependency('dconf'),
    cc.find_library('m', required : true)
]

executable(
    meson.project_name(),
    sources,
    dependencies: dependencies,
    install: true
)
