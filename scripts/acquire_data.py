"""Download the exact public inputs. Uses Python's standard library only."""
from pathlib import Path
import hashlib
import json
import tarfile
import urllib.request
import zipfile

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
DATA.mkdir(exist_ok=True)
RAW = DATA / "diabetes_012_health_indicators_BRFSS2015.csv"
SHA256 = "a971809d0786d2d7d7f6070f83dfe8af9d860ea33a79e0e2701c8a49f78f9861"
KAGGLE = "https://www.kaggle.com/api/v1/datasets/download/alexteboul/diabetes-health-indicators-dataset"
AGRIDAT = "https://cloud.r-project.org/src/contrib/agridat_1.26.tar.gz"
TOOLS = ROOT / ".tools"
TOOLS.mkdir(exist_ok=True)

def download(url, path):
    with urllib.request.urlopen(url, timeout=90) as response, path.open("wb") as target:
        while chunk := response.read(1024 * 1024):
            target.write(chunk)

if not RAW.exists():
    archive = TOOLS / "brfss_original.zip"
    if not archive.exists():
        download(KAGGLE, archive)
    with zipfile.ZipFile(archive) as z:
        RAW.write_bytes(z.read(RAW.name))
actual = hashlib.sha256(RAW.read_bytes()).hexdigest()
if actual != SHA256:
    raise RuntimeError("Raw dataset checksum differs from the verified version. Review before sampling.")

archive = TOOLS / "agridat_1.26.tar.gz"
if not archive.exists():
    download(AGRIDAT, archive)
with tarfile.open(archive) as z:
    for name in ("cochran.crd", "gomez.seedrate", "goulden.latin"):
        member = z.extractfile(f"agridat/data/{name}.txt")
        assert member is not None
        (DATA / f"{name}.tsv").write_bytes(member.read())
manifest = {
    "raw_file": RAW.name, "sha256": actual, "acquired_on": "2026-10-04",
    "source": "Alex Teboul's Kaggle derivative of CDC BRFSS 2015",
    "download_url": KAGGLE,
    "source_page": "https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset",
    "original_survey": "https://www.cdc.gov/brfss/annual_data/annual_2015.html",
    "supplement_package": "agridat 1.26", "supplement_download": AGRIDAT,
    "supplement_files": [f"{n}.tsv" for n in ("cochran.crd", "gomez.seedrate", "goulden.latin")],
}
(DATA / "provenance.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
print("Verified BRFSS CSV and extracted three documented experimental supplements.")
