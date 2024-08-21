project('blog')

src_dir = 'notes'
page_dir = 'pages'

source_docs = [
  '2022_igalia_graphics_team.md',
  'android_swrast.md',
  'baremetal-risc-v.md',
  'converting_from_3d_to_2d.md',
  'digital_garden.md',
  'freedreno_journey.md',
  'generating-video.md',
  'global_game_jam_2023.md',
  'mesa_23_1_contributions_behind_the_scenes.md',
  'n64brew-gamejam-2021.md',
  'rasterizing-triangles.md',
  'vulkanised_2024.md',
]

page_docs = [
  'about.md',
  'now.md',
]

source_doc_no_ext = []
foreach source : source_docs
  source_doc_no_ext += source.substring(0, -3)
endforeach

page_doc_no_ext = []
foreach source : page_docs
  page_doc_no_ext += source.substring(0, -3)
endforeach

pandoc = find_program('pandoc')
link_gen = join_paths(meson.source_root(), 'tools/link_gen.lua')
note = join_paths(meson.source_root(), 'tools/note.lua')
front_page = join_paths(meson.source_root(), 'tools/front_page.lua')
plantuml = join_paths(meson.source_root(), 'tools/pandoc-plantuml.py')
main_template = join_paths(meson.source_root(), 'templates/main.html')
rss_gen = join_paths(meson.source_root(), 'tools/rss_gen.py')
meta_files = []
lua_env = {'LUA_PATH' : meson.source_root() + '/?.lua' + ';;'}

foreach source : source_doc_no_ext
  source_file = join_paths(src_dir, source + '.md')
  meta_file = source + '.meta'
  html_file = source + '.html'
  meta = custom_target(meta_file,
                       input : [link_gen, source_file],
                       output : meta_file,
                       command : [pandoc, '--write', '@INPUT@', '-o', '@OUTPUT@'],
                       env : lua_env)
  meta_files += meta
  html = custom_target(html_file,
                       input : [main_template, note, plantuml, meta, source_file],
                       output : html_file,
                       command : [pandoc, '-s', '--template', '@INPUT0@',
                                  '--lua-filter', '@INPUT1@',
                                  '--filter', '@INPUT2@',
                                  '@INPUT4@',
                                  '--highlight-style=pygments',
                                  '-o', '@OUTPUT@',
                                  '-V', 'build_root=@0@'.format(meson.build_root())],
                       env : lua_env,
                       install : true,
                       install_dir : 'notes')
endforeach

foreach source : page_doc_no_ext
  source_file = join_paths(page_dir, source + '.md')
  html_file = source + '.html'
  custom_target(html_file,
                input : [main_template, source_file, plantuml],
                output : html_file,
                command : [pandoc, '-s', '--template', '@INPUT0@',
                           '@INPUT1@',
                           '--highlight-style=pygments',
                           '-M', 'main_class=html-main-page',
                           '-M', 'main_container=main-container-page',
                           '--filter', '@INPUT2@',
                           '-V', 'build_root=@0@'.format(meson.build_root()),
                           '-o', '@OUTPUT@'],
                env : lua_env,
                install : true,
                install_dir : '')
endforeach

# Generate index.html
custom_target('index.html',
              input : [front_page, main_template, 'main.md', meta_files],
              output : 'index.html',
              command : [pandoc, '-s', '--lua-filter', '@INPUT0@',
                         '--template', '@INPUT1@',
                         '@INPUT2@',
                         '--metadata=note_list:@0@'.format(' '.join(source_doc_no_ext)),
                         '-V', 'build_root=@0@'.format(meson.build_root()),
                         '-o', '@OUTPUT@'],
              env : lua_env,
              install : true,
              install_dir : '')

custom_target('feed.xml',
              input : [rss_gen, meta_files],
              output : 'feed.xml',
              command : [rss_gen, meson.source_root(), meson.build_root(), '@OUTPUT@'],
              env : lua_env,
              install : true,
              install_dir : '')

custom_target('graphics_feed.xml',
              input : [rss_gen, meta_files],
              output : 'graphics_feed.xml',
              command : [rss_gen, meson.source_root(), meson.build_root(), '@OUTPUT@', 'igalia', 'graphics'],
              env : lua_env,
              install : true,
              install_dir : '')
