sources = [
    'Application.vala',
    'HeaderBar.vala',
    'MainWindow.vala',
    'SettingsDialog.vala',
    'Strings.vala',
    'Utilities.vala',
]

dependencies = [
    dependency('gtk+-3.0'),
    dependency('granite'),
    dependency('libhandy-1')
]

executable(
    meson.project_name(),
    sources,
    dependencies: dependencies,
    install: true
)
