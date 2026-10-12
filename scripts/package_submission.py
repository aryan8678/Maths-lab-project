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
    assert len(presentation.findall('.//p:sldId',NS))==12
    assert sum(n.startswith('ppt/notesSlides/notesSlide') and n.endswith('.xml') for n in z.namelist())==12
    assert any('/charts/chart' in n and n.endswith('.xml') for n in z.namelist())
    text_ns={'a':'http://schemas.openxmlformats.org/drawingml/2006/main'}
    for i in range(1,13):
        tree=etree.fromstring(z.read(f'ppt/slides/slide{i}.xml'))
        visible=' '.join(tree.xpath('//a:t/text()',namespaces=text_ns))
        assert not any(term in visible.lower() for term in ['unweighted data proportions','original sample remains available'])
        assert 'LAB' in visible
        if i<10:assert not any(term in visible for term in ['Chi-square','ANOVA','CRD','RBD','Latin Square'])
        elif i==10:assert all(term in visible for term in ['LAB 10','Chi-square']) and 'ANOVA' not in visible
        elif i==11:assert all(term in visible for term in ['LAB 11','ANOVA','CRD','RBD','Latin Square'])
        else:assert all(term in visible for term in ['Conclusion','Limits','Next steps'])
assert len(PdfReader(OUT/'Diabetes_Statistics_Report.pdf').pages)==18
assert len(PdfReader(OUT/'Diabetes_Statistics_Slides.pdf').pages)==12
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
evidence={'slides':12,'intro_slides':1,'content_slides':11,
          'experiments_10_11':'separate content slides 9 and 10; conclusion on final content slide 11',
          'lab_labels':'Every slide identifies its syllabus exercise at the top',
          'report_pages':18,'drawings':29,'completed_scripts':17,
          'source_commit':'2bfebaedd34c387206d70c8a362234e1cd425c2d',
          'analysis_validation':'PASS: tests/validate_project.R',
          'visual_review':'All slide, report and atlas pages inspected; layout corrections verified.',
          'study_guide':{'path':'report/presentation_content.md',
                         'scope':'Intro and all eleven content slides; foundations, 29 drawings, R implementation, 48 review questions',
                         'sha256':hashlib.sha256((ROOT/'report/presentation_content.md').read_bytes()).hexdigest()},
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
