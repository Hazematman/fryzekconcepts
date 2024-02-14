#!/usr/bin/env python

"""
Pandoc filter to process code blocks with class "plantuml" into
plant-generated images.
Needs `plantuml.jar` from http://plantuml.com/.
"""

import os
import sys
import subprocess
from pathlib import Path

from pandocfilters import toJSONFilter, Para, Image
from pandocfilters import get_filename4code, get_caption, get_extension, stringify

PLANTUML_BIN = os.environ.get("PLANTUML_BIN", "plantuml")

counter = 0

def rel_mkdir_symlink(src, dest):
    dest_dir = os.path.dirname(dest)
    if dest_dir and not os.path.exists(dest_dir):
        os.makedirs(dest_dir)

    if os.path.exists(dest):
        os.remove(dest)

    src = os.path.relpath(src, dest_dir)
    os.symlink(src, dest)


def plantuml(key, value, format_, meta):
    global counter
    if key == "CodeBlock":
        [[ident, classes, keyvals], code] = value
        if "plantuml" in classes:
            title = stringify(meta.get("title")).replace(" ", "_")
            caption, typef, keyvals = get_caption(keyvals)

            if meta.get("plantuml-format"):
                pformat = meta.get("plantuml-format", None)
                filetype = get_extension(format_, pformat["c"][0]["c"])
            else:
                filetype = get_extension(format_, "png", html="svg", latex="png")

            src_folder = f"build/diag/{title}/"
            src = f"{src_folder}/{counter}.uml"
            filename = f"{counter}.{filetype}"
            base_folder = f"assets/diag/{title}"
            base = f"{base_folder}/{filename}"
            dest_folder = f"html/{base_folder}"
            dest = f"{dest_folder}/{filename}"

            Path(src_folder).mkdir(parents=True, exist_ok=True)
            Path(dest_folder).mkdir(parents=True, exist_ok=True)

            # Generate image only once
            txt = code.encode(sys.getfilesystemencoding())
            if not txt.startswith(b"@start"):
                txt = b"@startuml\n" + txt + b"\n@enduml\n"
            with open(src, "wb") as f:
                f.write(txt)

            subprocess.check_call(PLANTUML_BIN.split() + ["-t" + filetype, src,
                                                          "-o",
                                                          os.path.abspath(dest_folder)])
            sys.stderr.write("Created image " + dest + "\n")

            counter += 1
            return Para([Image([ident, [], keyvals], caption, ["/"+base, typef])])


def main():
    toJSONFilter(plantuml)


if __name__ == "__main__":
    main()
