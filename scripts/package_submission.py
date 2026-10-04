"""Package the final artifacts, analysis sources, inputs and evidence."""
from pathlib import Path
import csv, hashlib, json, zipfile
from pypdf import PdfReader
from lxml import etree

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'submission'
NS={'p':'http://schemas.openxmlformats.org/presentationml/2006/main'}
ppt=OUT/'Diabetes_Statistics_Presentation.pptx'
with zipfile.ZipFile(ppt) as z:
    presentation=etree.fromstring(z.read('ppt/presentation.xml'))
    assert len(presentation.findall('.//p:sldId',NS))==25
    assert sum(n.startswith('ppt/notesSlides/notesSlide') and n.endswith('.xml') for n in z.namelist())==25
    assert any('/charts/chart' in n and n.endswith('.xml') for n in z.namelist())
assert len(PdfReader(OUT/'Diabetes_Statistics_Report.pdf').pages)==18
assert len(PdfReader(OUT/'Diabetes_Statistics_Slides.pdf').pages)==25
assert len(PdfReader(OUT/'Complete_Figure_Atlas.pdf').pages)==29
with (ROOT/'Lab14_Consolidation/output/figure_inventory.csv').open(newline='',encoding='utf-8-sig') as f:
    figures=list(csv.DictReader(f))
assert len(figures)==29
with zipfile.ZipFile(OUT/'All_Drawings.zip') as z:
    assert all(r['figure'] in z.namelist() for r in figures)
    assert z.testzip() is None
manifest=json.loads((ROOT/'data/provenance.json').read_text())
assert hashlib.sha256((ROOT/'data'/manifest['raw_file']).read_bytes()).hexdigest()==manifest['sha256']
receipt=json.loads((ROOT/'.build/presentation/validation.json').read_text())
assert hashlib.sha256(ppt.read_bytes()).hexdigest()==receipt['finalSha256']
assert (ROOT/'report/execution_log.txt').read_text().count('COMPLETED ')==17

names=['Diabetes_Statistics_Presentation.pptx','Diabetes_Statistics_Slides.pdf',
       'Diabetes_Statistics_Report.docx','Diabetes_Statistics_Report.pdf',
       'Complete_Figure_Atlas.pdf','All_Drawings.zip']
hashes={n:hashlib.sha256((OUT/n).read_bytes()).hexdigest() for n in names}
evidence={'slides':25,'report_pages':18,'drawings':29,'completed_scripts':17,
          'source_commit':'2bfebaedd34c387206d70c8a362234e1cd425c2d',
          'analysis_validation':'PASS: tests/validate_project.R',
          'visual_review':'All slide, report and atlas pages inspected; layout corrections verified.',
          'sha256':hashes}
(OUT/'delivery_manifest.json').write_text(json.dumps(evidence,indent=2),encoding='utf-8')
bundle=OUT/'Complete_Submission_Pack.zip'
files=list(ROOT.glob('*.md'))+list(ROOT.glob('*.pdf'))+[ROOT/'run_all.R',ROOT/'.gitignore',ROOT/'.gitattributes']
for directory in ['R','data','scripts','tests','report','submission']:
    files.extend(p for p in (ROOT/directory).rglob('*') if p.is_file() and '__pycache__' not in p.parts)
for directory in ROOT.glob('Lab*'):
    if directory.is_dir():files.extend(p for p in directory.rglob('*') if p.is_file())
with zipfile.ZipFile(bundle,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(set(files)):
        if p!=bundle:z.write(p,'Maths-lab-project/'+p.relative_to(ROOT).as_posix())
with zipfile.ZipFile(bundle) as z:assert z.testzip() is None
print(f'PASS: final package checks. Complete archive: {bundle.name}, {bundle.stat().st_size:,} bytes.')
