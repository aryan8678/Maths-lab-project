"""Prepare the current presentation and shared report data."""
from pathlib import Path
import runpy
runpy.run_path(str(Path(__file__).with_name('build_compact_content.py')),run_name='__main__')
