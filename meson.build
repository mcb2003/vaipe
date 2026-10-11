project('vaipe', 'vala', 'c',
  version: '0.1.0',
  license: 'GPL-3.0-only',
)

# Internationalisation:
subdir('po')
cfg = configuration_data()
cfg.set_quoted('GETTEXT_PACKAGE', gettext_package)
cfg.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config = configure_file(
  input: 'src/config.vala.in',
  output: 'config.vala',
  configuration: cfg,
)

executable('vaipe',
config,
  'src/main.vala',
  'src/application.vala',
  'src/window.vala',
  'src/command_entry.vala',
  c_args: ['-w', '-DGETTEXT_PACKAGE="' + gettext_package + '"'],
  dependencies: [
    dependency('gtk4'),
    dependency('gtksourceview-5'),
  ],
  install: true,
)

i18n.merge_file(
  input: 'data/vip.thefake.vaipe.desktop.in',
  output: 'vip.thefake.vaipe.desktop',
  type: 'desktop',
  po_dir: 'po',
  install: true,
  install_dir: get_option('datadir') / 'applications',
)
