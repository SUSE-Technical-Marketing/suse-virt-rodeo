import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import render_pdf  # noqa: E402


class OptimizeImagesCacheTest(unittest.TestCase):
    def _optimize(self, html, cache, converted):
        def fake_run(cmd):
            # cmd: [im, src_spec, ..., out]; record source bytes, write output
            src = Path(cmd[1])
            Path(cmd[-1]).write_bytes(src.read_bytes())
            converted.append(src.name)

        with mock.patch.object(render_pdf, "run", fake_run), \
                mock.patch.object(render_pdf, "imagemagick_cmd", lambda: "magick"):
            render_pdf.optimize_images(html, cache)
        return html.read_text()

    def test_image_updated_at_same_path_is_reconverted(self):
        with tempfile.TemporaryDirectory() as d:
            d = Path(d)
            img = d / "example.png"
            html = d / "g.html"
            cache = d / "imgcache"
            page = f'<img src="file://{img}">'

            img.write_bytes(b"old")
            html.write_text(page)
            converted = []
            out1 = self._optimize(html, cache, converted)
            cached1 = Path(out1.split("file://")[1].rstrip('">'))
            self.assertEqual(cached1.read_bytes(), b"old")

            # Same path, new contents (different size, so the test does not
            # depend on filesystem mtime granularity).
            img.write_bytes(b"new-screenshot")
            html.write_text(page)
            out2 = self._optimize(html, cache, converted)
            cached2 = Path(out2.split("file://")[1].rstrip('">'))
            self.assertEqual(cached2.read_bytes(), b"new-screenshot")
            self.assertEqual(converted, ["example.png", "example.png"])

    def test_same_size_edit_with_new_mtime_is_reconverted(self):
        with tempfile.TemporaryDirectory() as d:
            d = Path(d)
            img = d / "example.png"
            html = d / "g.html"
            cache = d / "imgcache"
            page = f'<img src="file://{img}">'

            img.write_bytes(b"AAAA")
            os.utime(img, ns=(1_000_000_000, 1_000_000_000))
            html.write_text(page)
            converted = []
            self._optimize(html, cache, converted)

            img.write_bytes(b"BBBB")
            os.utime(img, ns=(2_000_000_000, 2_000_000_000))
            html.write_text(page)
            out = self._optimize(html, cache, converted)
            cached = Path(out.split("file://")[1].rstrip('">'))
            self.assertEqual(cached.read_bytes(), b"BBBB")

    def test_unchanged_image_hits_cache(self):
        with tempfile.TemporaryDirectory() as d:
            d = Path(d)
            img = d / "example.png"
            html = d / "g.html"
            cache = d / "imgcache"
            page = f'<img src="file://{img}">'

            img.write_bytes(b"same")
            converted = []
            for _ in range(2):
                html.write_text(page)
                self._optimize(html, cache, converted)
            self.assertEqual(converted, ["example.png"])


if __name__ == "__main__":
    unittest.main()
