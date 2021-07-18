# project name and programming language
project('com.github.kicsyromy.tapet', 'vala', 'c')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

subdir('src')
subdir('data')
subdir('po')
