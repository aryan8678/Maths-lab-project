import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath,pathToFileURL} from 'node:url';
// Resolve the supplied artifact runtime rather than installing a substitute.
const ROOT=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
const RUNTIME='C:/Users/yasha/.cache/codex-runtimes/codex-primary-runtime/dependencies';
process.env.RUNTIME_NODE_MODULES=path.join(RUNTIME,'node/node_modules');
const SKILL='C:/Users/yasha/.codex/plugins/cache/openai-primary-runtime/presentations/26.930.11008/skills/presentations';
const {Presentation,PresentationFile,FileBlob}=await import(pathToFileURL(path.join(RUNTIME,'node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs')).href);
const {finalizePresentation,resolvePresentationFont,applyPresentationChartFont}=await import(pathToFileURL(path.join(SKILL,'container_tools/artifact_tool_utils.mjs')).href);
const DATA=JSON.parse(await fs.readFile(path.join(ROOT,'.build/content.json'),'utf8'));
const font=resolvePresentationFont({fontFamily:'Arial'});
const pres=Presentation.create({slideSize:{width:1280,height:720}});
const INK='#183044',MUTED='#415566',BLUE='#176D8C',ORANGE='#D87945',WHITE='#FFFFFF';
function text(slide,value,x,y,w,h,size=25,bold=false,color=INK){
 const shape=slide.shapes.add({geometry:'textbox',name:'text',position:{left:x,top:y,width:w,height:h},fill:'none',line:{fill:'none',width:0}});
 shape.text=value;
 shape.text.style={typeface:font,fontSize:size,bold,color,autoFit:'none',wrap:true};
 return shape;
}
function table(slide,values,x,y,w,h,size=23,widths){
 const t=slide.tables.add({rows:values.length,columns:values[0].length,left:x,top:y,width:w,height:h,values,...(widths?{columnWidths:widths}:{})});
 t.borders.assign({fill:'#D6E0E5',width:1,style:'solid'});
 t.styleOptions={headerRow:true,bandedRows:true};
 for(let r=0;r<values.length;r++)for(let c=0;c<values[0].length;c++){
  const cell=t.getCell(r,c);cell.fill=r===0?BLUE:(r%2===0?'#F0F5F7':WHITE);
  cell.text.style={typeface:font,fontSize:size,bold:r===0,color:r===0?WHITE:INK,alignment:c===0?'left':'center',autoFit:'none'};
 }
 return t;
}
async function image(slide,p,x,y,w,h){
 const bytes=await fs.readFile(path.join(ROOT,p));
 slide.images.add({blob:new Uint8Array(bytes),contentType:'image/png',alt:path.basename(p,'.png').replaceAll('_',' '),fit:'contain',position:{left:x,top:y,width:w,height:h}});
}
for(let i=0;i<DATA.slides.length;i++){
 const s=DATA.slides[i],slide=pres.slides.add();
 slide.background.fill=WHITE;
 if(s.kind==='cover'){
  slide.background.fill='#EDF4F6';
  text(slide,'Statistical analysis of diabetes\nand lifestyle indicators',68,90,1140,158,57,true);
  text(slide,s.body,72,290,1100,85,29,false,MUTED);
  text(slide,DATA.authors.join('\n'),72,428,1100,165,26,false,INK);
 }else{
  text(slide,s.title,56,32,1168,72,43,true);
  if(s.kind==='text'){
   const paragraphs=s.body.split('\n');
   let y=140;
   for(const item of paragraphs){
    const height=i===24?84:112;
    text(slide,item,64,y,1150,height,i===24?26:28,false,INK);y+=height+10;
   }
  }else if(s.kind==='classchart'){
   const chart=slide.charts.add('bar',{position:{left:54,top:152,width:690,height:440},categories:s.chart.categories,
    series:s.chart.series.map((v,k)=>({...v,fill:k===0?BLUE:ORANGE})),
    barOptions:{direction:'column',grouping:'clustered',gapWidth:100},hasLegend:true,
    legend:{position:'bottom',textStyle:{typeface:font,fontSize:21}},
    xAxis:{textStyle:{typeface:font,fontSize:21},line:{fill:'#B7C7CE',width:1}},
    yAxis:{title:'Respondents (%)',min:0,max:100,majorUnit:25,numberFormatCode:'0',textStyle:{typeface:font,fontSize:20},majorGridlines:{fill:'#DDE5E9',width:1}},
    chartFill:WHITE,plotAreaFill:WHITE,chartLine:{fill:'none',width:0}});
   applyPresentationChartFont(chart,{fontFamily:font});
   text(slide,s.body,794,158,420,390,26);
  }else if(s.kind==='process'){
   const xs=[64,356,648,940];
   s.steps.forEach((step,k)=>{
    const box=slide.shapes.add({geometry:'rect',position:{left:xs[k],top:145,width:240,height:120},fill:'#EDF4F6',line:{fill:BLUE,width:2}});
    box.text=step.join('\n');box.text.style={typeface:font,fontSize:27,color:INK,bold:false,alignment:'center',autoFit:'none'};
    if(k<3)slide.shapes.add({geometry:'rightArrow',position:{left:xs[k]+250,top:188,width:32,height:28},fill:BLUE,line:{fill:'none',width:0}});
   });
   text(slide,s.body,64,325,1150,245,28);
  }else if(s.kind==='table'){
   const bodyHeight=s.body.length>210?150:90;
   text(slide,s.body,64,126,1150,bodyHeight,26);
   const top=bodyHeight+145;
   table(slide,s.table,64,top,1150,Math.min(390,610-top),24);
  }else if(s.kind==='figure'){
   await image(slide,s.figures[0],42,148,820,452);
   text(slide,s.body,900,154,328,450,24);
  }else if(s.kind==='twofig'){
   text(slide,s.body,64,118,1150,104,24);
   await image(slide,s.figures[0],36,230,602,354);
   await image(slide,s.figures[1],644,230,602,354);
  }else if(s.kind==='figuretable'){
   text(slide,s.body,64,116,1150,100,24);
   await image(slide,s.figures[0],26,240,686,365);
   table(slide,s.table,734,244,490,Math.min(350,50*s.table.length),i===7?19:21,i===7?[150,85,85,85,85]:undefined);
  }
  if(s.takeaway)text(slide,s.takeaway,64,622,1150,55,23,true,BLUE);
  if(i===24)text(slide,'References: CDC BRFSS 2015 | Alex Teboul (Kaggle) | MASS | agridat | NIST. Full links in notes and report.',64,676,1120,24,13,false,MUTED);
 }
 text(slide,String(i+1).padStart(2,'0'),1194,684,50,22,17,false,MUTED);
 slide.speakerNotes.textFrame.setText((s.notes||'')+'\nSources of calculations: the matching saved R exercise outputs. Main sample n=3000 unless stated otherwise. '+(s.figures||[]).join(', '));
 console.log(`Authored slide ${i+1}: ${s.title}`);
}
const build=path.join(ROOT,'.build/presentation');await fs.mkdir(build,{recursive:true});
const candidate=path.join(build,'candidate.pptx');await(await PresentationFile.exportPptx(pres)).save(candidate);
await fs.writeFile(path.join(build,'presentation.proto.json'),JSON.stringify(pres.toProto()));
const final=path.join(ROOT,'submission/Diabetes_Statistics_Presentation.pptx');
// Keep the previous generated revision before validating the new candidate.
try { await fs.rename(final,path.join(build,`previous-final-${Date.now()}.pptx`)); }
catch(error) { if(error.code!=='ENOENT')throw error; }
try { await fs.rename(path.join(build,'validation.json'),path.join(build,`previous-validation-${Date.now()}.json`)); }
catch(error) { if(error.code!=='ENOENT')throw error; }
const result=await finalizePresentation({workspaceDir:ROOT,candidatePath:candidate,finalPath:final,
 pythonExecutable:path.join(RUNTIME,'python/python.exe'),
 integrityValidatorPath:path.join(SKILL,'container_tools/inspect_presentation_package_integrity.py'),
 layoutValidatorPath:path.join(SKILL,'container_tools/inspect_presentation_layout_geometry.py'),
 layoutArgs:['--expected-slide-size-emu','12192000,6858000','--validate-heading-fit',
 ...[4,7,8,12,13,18,21,23,24].flatMap(n=>['--require-native-table-slide',String(n)])],
 explicitTotalSlideCount:25,requiredNativeChartOwnerSlides:[3],
 requiredNativeTableOwnerSlides:[4,7,8,12,13,18,21,23,24],
 materializeLiteralChartWorkbooks:true,fontPolicy:{basis:'design',families:[font]},
 verifyArtifactToolImport:true,receiptPath:path.join(build,'validation.json')});
console.log('Finalized presentation; validation receipt:',path.join(build,'validation.json'));
const verified=await PresentationFile.importPptx(await FileBlob.load(final));
const previewDir=path.join(build,'previews');await fs.mkdir(previewDir,{recursive:true});
for(let i=0;i<25;i++){
 const slide=verified.slides.items[i];
 const preview=await verified.export({slide,format:'png',scale:1.25});
 await fs.writeFile(path.join(previewDir,`slide-${String(i+1).padStart(2,'0')}.png`),new Uint8Array(await preview.arrayBuffer()));
 console.log('Rendered final slide',i+1);
}
