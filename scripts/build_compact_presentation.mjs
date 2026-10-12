import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath,pathToFileURL} from 'node:url';
const ROOT=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
const RT='C:/Users/yasha/.cache/codex-runtimes/codex-primary-runtime/dependencies';
process.env.RUNTIME_NODE_MODULES=path.join(RT,'node/node_modules');
// Locate the installed skill version rather than relying on a stale cache path.
const skillRoot='C:/Users/yasha/.codex/plugins/cache/openai-primary-runtime/presentations';
const versions=(await fs.readdir(skillRoot)).sort((a,b)=>a.localeCompare(b,undefined,{numeric:true}));
const SKILL=path.join(skillRoot,versions.at(-1),'skills/presentations');
const {Presentation,PresentationFile,FileBlob}=await import(pathToFileURL(path.join(RT,'node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs')).href);
const {finalizePresentation,resolvePresentationFont,applyPresentationChartFont}=await import(pathToFileURL(path.join(SKILL,'container_tools/artifact_tool_utils.mjs')).href);
const D=JSON.parse(await fs.readFile(path.join(ROOT,'.build/compact_content.json'),'utf8'));
const FONT=resolvePresentationFont({fontFamily:'Arial'});
const P=Presentation.create({slideSize:{width:1280,height:720}});
const INK='#183044',BLUE='#176D8C',TEAL='#269E91',ORANGE='#D87945',MUTED='#415566',WHITE='#FFFFFF',PALE='#EAF2F5';
function box(s,x,y,w,h,fill=WHITE,line='none'){
 return s.shapes.add({geometry:'rect',position:{left:x,top:y,width:w,height:h},fill,line:{fill:line,width:line==='none'?0:1}});
}
function txt(s,value,x,y,w,h,size=23,bold=false,color=INK){
 const t=s.shapes.add({geometry:'textbox',name:'text',position:{left:x,top:y,width:w,height:h},fill:'none',line:{fill:'none',width:0}});
 t.text=value;t.text.style={typeface:FONT,fontSize:size,bold,color,autoFit:'none',wrap:true};return t;
}
function rule(s,x,y,w=1196){box(s,x,y,w,2,'#CCDCE4');}
function table(s,values,x,y,w,h,size=21,widths,header=true){
 const t=s.tables.add({rows:values.length,columns:values[0].length,left:x,top:y,width:w,height:h,values,...(widths?{columnWidths:widths}:{})});
 t.borders.assign({fill:'#D6E0E5',width:1,style:'solid'});
 for(let r=0;r<values.length;r++)for(let c=0;c<values[0].length;c++){
  const cell=t.getCell(r,c);cell.fill=header&&r===0?BLUE:(r%2===0?PALE:WHITE);
  cell.text.style={typeface:FONT,fontSize:size,bold:header&&r===0,color:header&&r===0?WHITE:INK,alignment:c===0?'left':'center',autoFit:'none'};
 }
 return t;
}
async function pic(s,name,x,y,w,h){
 const bytes=await fs.readFile(path.join(ROOT,'.build/pitch_figures',name+'.png'));
 s.images.add({blob:new Uint8Array(bytes),contentType:'image/png',alt:name.replaceAll('_',' '),fit:'contain',position:{left:x,top:y,width:w,height:h}});
}
function chart(s,type,data,x,y,w,h,opts={}){
 const colors=[BLUE,ORANGE,TEAL,'#7660A7'];
 const c=s.charts.add(type,{position:{left:x,top:y,width:w,height:h},categories:data.categories,
  series:data.series.map((v,i)=>({...v,fill:colors[i%4],line:{fill:colors[i%4],width:2},marker:{symbol:type==='line'?'circle':'none',size:4}})),
  hasLegend:data.series.length>1,legend:{position:'bottom',textStyle:{typeface:FONT,fontSize:16}},
  xAxis:{textStyle:{typeface:FONT,fontSize:17},line:{fill:'#AABCC6',width:1}},
  yAxis:{textStyle:{typeface:FONT,fontSize:17},numberFormatCode:'0',majorGridlines:{fill:'#DFE7EB',width:1},line:{fill:'none',width:0}},
  chartFill:WHITE,plotAreaFill:WHITE,chartLine:{fill:'none',width:0},
  barOptions:{direction:'column',grouping:'clustered',gapWidth:65},...opts});
 applyPresentationChartFont(c,{fontFamily:FONT});return c;
}
function metric(s,value,label,x,y,w=300){txt(s,value,x,y,w,56,43,true,BLUE);txt(s,label,x,y+54,w,31,21,false,MUTED);}
for(let i=0;i<D.slides.length;i++){
 const d=D.slides[i],s=P.slides.add();s.background.fill=WHITE;
 if(i===0){
  box(s,0,0,1280,18,BLUE);txt(s,'Diabetes and\nlifestyle indicators',58,83,1150,158,64,true);
  txt(s,d.lab_header,62,34,1150,30,21,true,BLUE);
  txt(s,d.body,62,270,1100,90,31,false,BLUE);rule(s,62,387,1150);
  txt(s,D.authors.join('\n'),62,419,1150,176,27);
  txt(s,'Data  →  graphs  →  models  →  statistical tests',62,630,1140,46,29,true,BLUE);
 }else{
  txt(s,d.lab_header,62,8,1178,26,18,true,BLUE);
  box(s,40,40,5,46,BLUE);txt(s,d.title,62,36,1178,58,38,true);
  txt(s,d.body,42,102,1196,54,23,false,MUTED);
  if(d.kind==='dataset'){
   d.stats.forEach((v,k)=>metric(s,...v,42+k*402,161,375));rule(s,42,250);
   txt(s,'Health status in the sample',42,269,600,32,24,true);
   chart(s,'bar',d.chart,35,306,601,305,{hasLegend:false,
    yAxis:{min:0,max:3000,majorUnit:1000,textStyle:{typeface:FONT,fontSize:17},majorGridlines:{fill:'#DFE7EB',width:1}},
    dataLabels:{showValue:true,position:'outEnd',textStyle:{typeface:FONT,fontSize:20}},
    series:[{...d.chart.series[0],fill:BLUE,points:[{idx:0,fill:BLUE},{idx:1,fill:TEAL},{idx:2,fill:ORANGE}]}]});
   txt(s,'Key variables',662,269,575,32,24,true);table(s,d.table,662,308,578,280,21,[245,333]);
   txt(s,'Source: CDC BRFSS 2015, processed by Alex Teboul on Kaggle.',662,601,574,35,16,false,MUTED);
  }else if(d.kind==='preparation'){
   d.stages.forEach((v,k)=>{
    const x=42+k*304;box(s,x,163,270,118,PALE,BLUE);
    txt(s,v[0],x+14,175,244,38,29,true,BLUE);txt(s,v[1],x+14,225,244,35,23);
    if(k<3)s.shapes.add({geometry:'rightArrow',position:{left:x+278,top:210,width:19,height:20},fill:BLUE,line:{fill:'none',width:0}});
   });
   txt(s,'Types used in R',42,313,610,34,25,true);txt(s,'Quality checks',690,313,550,34,25,true);
   table(s,[['Type','Examples'],...d.types],42,362,608,188,22,[229,379]);
   table(s,[['Check','Result'],...d.checks],690,362,550,188,21,[367,183]);
   rule(s,42,578);txt(s,'Import CSV  →  label categories  →  export clean data for the exercises',42,596,1190,34,25,true,BLUE);
  }else if(d.kind==='outliers'){
   txt(s,'Detect unusual BMI values',42,155,685,32,24,true);txt(s,'Compare before and after',744,155,495,32,24,true);
   await pic(s,'bmi_fences',28,187,686,418);await pic(s,'before_after',735,186,500,260);
   table(s,d.table,744,454,496,174,19,[190,153,153]);
  }else if(d.kind==='summary'){
   table(s,d.table,42,160,1196,169,22,[366,208,207,207,208]);
   txt(s,'Education: group sizes',42,357,385,34,23,true);txt(s,'Sex: sample share',459,357,370,34,23,true);txt(s,'BMI: distribution shape',871,357,369,34,23,true);
   const edu={...d.education,categories:['No school','Primary','Some high school','High school','Some college','Graduate']};
   chart(s,'bar',edu,26,398,404,224,{hasLegend:false,barOptions:{direction:'bar',gapWidth:50},
    xAxis:{textStyle:{typeface:FONT,fontSize:16}},yAxis:{min:0,max:1500,majorUnit:500,textStyle:{typeface:FONT,fontSize:15},majorGridlines:{fill:'#DFE7EB',width:1}}});
   chart(s,'pie',d.sex,469,398,345,224,{hasLegend:true,
    series:[{...d.sex.series[0],points:[{idx:0,fill:BLUE},{idx:1,fill:ORANGE}]}],
    dataLabels:{showPercent:true,position:'bestFit',textStyle:{typeface:FONT,fontSize:19},numberFormatCode:'0.0%'}});
   await pic(s,'density',866,395,370,230);
  }else if(d.kind==='correlation'){
   txt(s,'Poor-health days and BMI',42,157,700,31,24,true);txt(s,'BMI by health group',790,157,450,31,24,true);
   await pic(s,'scatter',24,197,724,354);await pic(s,'status_box',786,197,450,287);
   table(s,d.table,42,564,690,65,20,[172,172,174,172]);
   txt(s,'Average BMI',793,500,440,28,21,true);table(s,d.means,790,540,450,89,19,[150,150,150]);
  }else if(d.kind==='multiple'){
   d.stats.forEach((v,k)=>metric(s,...v,42+k*255,162,235));
   txt(s,'Which predictors matter?',42,274,510,32,25,true);table(s,d.table,42,321,510,252,22,[282,114,114]);
   txt(s,'Check the fitted model',580,161,658,31,25,true);await pic(s,'diagnostics',577,202,658,404);
   txt(s,'Residuals show uneven spread and a long upper tail.',580,608,658,31,19,false,MUTED);
  }else if(d.kind==='distributions'){
   d.descriptions.forEach((v,k)=>{
    const x=42+k*407;txt(s,v[0],x,168,376,34,28,true,BLUE);
    txt(s,v[1],x,219,376,68,21);txt(s,v[2],x,557,376,29,23,true,BLUE);txt(s,v[3],x,593,376,46,21);
   });
   chart(s,'bar',d.binomial,27,301,384,231,{xAxis:{textStyle:{typeface:FONT,fontSize:17}},legend:{position:'bottom',textStyle:{typeface:FONT,fontSize:16}}});
   await pic(s,'normal',449,291,370,258);
   chart(s,'bar',d.poisson,853,301,390,231,{xAxis:{textStyle:{typeface:FONT,fontSize:15}},legend:{position:'bottom',textStyle:{typeface:FONT,fontSize:16}}});
  }else if(d.kind==='sample_tests'){
   table(s,d.table,42,166,1196,211,22,[389,243,410,154]);
   txt(s,'BMI: compare female and male means',42,394,578,33,23,true,BLUE);
   txt(s,'Positive status: compare smoking groups',668,394,572,33,23,true,BLUE);
   chart(s,'bar',d.bmi_sex,27,429,585,157,{hasLegend:false,
    series:[{...d.bmi_sex.series[0],points:[{idx:0,fill:BLUE},{idx:1,fill:ORANGE}]}],
    yAxis:{min:0,max:35,majorUnit:10,title:{text:'Mean BMI',textStyle:{typeface:FONT,fontSize:17}},textStyle:{typeface:FONT,fontSize:17},majorGridlines:{fill:'#DFE7EB',width:1}},
    dataLabels:{showValue:true,position:'outEnd',numberFormatCode:'0.00',textStyle:{typeface:FONT,fontSize:21}}});
   chart(s,'bar',d.smoking,654,429,585,157,{hasLegend:false,
    series:[{...d.smoking.series[0],points:[{idx:0,fill:BLUE},{idx:1,fill:ORANGE}]}],
    yAxis:{min:0,max:25,majorUnit:10,title:{text:'Positive status (%)',textStyle:{typeface:FONT,fontSize:17}},textStyle:{typeface:FONT,fontSize:17},majorGridlines:{fill:'#DFE7EB',width:1}},
    dataLabels:{showValue:true,position:'outEnd',numberFormatCode:'0.0"%"',textStyle:{typeface:FONT,fontSize:21}}});
   txt(s,d.bmi_caption,42,588,580,48,20);
   txt(s,d.smoking_caption,668,588,572,48,20);
  }else if(d.kind==='paired_tests'){
   txt(s,'Independent: different respondents',42,166,579,33,24,true,BLUE);
   txt(s,'Paired: the same 29 CBT patients',668,166,572,33,24,true,BLUE);
   txt(s,'BRFSS: 1,667 females and 1,333 males.\nCompare physical poor-health days.',42,211,578,58,21);
   txt(s,'MASS dataset: before/after weights (lb).\nBlue lines: patients. Orange line: mean.',668,211,572,58,21);
   chart(s,'bar',d.physical_sex,27,278,585,204,{hasLegend:false,
    series:[{...d.physical_sex.series[0],points:[{idx:0,fill:BLUE},{idx:1,fill:ORANGE}]}],
    yAxis:{min:0,max:6,majorUnit:2,title:{text:'Mean physical poor-health days',textStyle:{typeface:FONT,fontSize:16}},textStyle:{typeface:FONT,fontSize:17},majorGridlines:{fill:'#DFE7EB',width:1}},
    dataLabels:{showValue:true,position:'outEnd',numberFormatCode:'0.00',textStyle:{typeface:FONT,fontSize:21}}});
   const series=d.paired.series.map((v,k)=>({...v,line:{fill:k===29?ORANGE:'#A0C7D6',width:k===29?3:1},marker:{symbol:'none'}}));
   chart(s,'line',d.paired,654,278,585,204,{series,hasLegend:false,
    yAxis:{min:65,max:110,majorUnit:15,title:{text:'Weight (lb)',textStyle:{typeface:FONT,fontSize:17}},textStyle:{typeface:FONT,fontSize:17},majorGridlines:{fill:'#DFE7EB',width:1}}});
   table(s,d.independent_table,42,498,576,132,20,[297,279]);
   table(s,d.paired_table,668,498,572,132,20,[294,278]);
  }else if(d.kind==='review'){
   txt(s,'What we found',42,166,750,33,25,true,BLUE);
   d.findings.forEach((v,k)=>{
    const y=209+k*101;txt(s,v[0],42,y,748,31,23,true);
    txt(s,v[1],42,y+35,748,58,21);
    if(k<3)rule(s,42,y+94,748);
   });
   box(s,823,170,2,442,'#CCDCE4');
   txt(s,'Limits',860,166,375,34,25,true,BLUE);
   txt(s,d.limits.join('\n'),860,214,377,151,21);
   txt(s,'Next steps',860,391,375,34,25,true,BLUE);
   txt(s,d.next_steps.join('\n'),860,439,377,156,21);
  }else if(d.kind==='chi'){
   table(s,d.chi,42,176,1196,171,23,[828,184,184]);
   txt(s,'Blood pressure: larger difference',42,370,574,34,24,true,BLUE);
   txt(s,'Smoking: smaller difference',668,370,572,34,24,true,BLUE);
   const settings={hasLegend:false,yAxis:{min:0,max:35,majorUnit:10,
    title:{text:'Positive status (%)',textStyle:{typeface:FONT,fontSize:17}},
    textStyle:{typeface:FONT,fontSize:17},majorGridlines:{fill:'#DFE7EB',width:1}},
    dataLabels:{showValue:true,position:'outEnd',numberFormatCode:'0.0"%"',textStyle:{typeface:FONT,fontSize:21}}};
   for(const [data,x] of [[d.highbp,27],[d.smoking,654]]){
    chart(s,'bar',data,x,408,583,203,{...settings,
     series:[{...data.series[0],points:[{idx:0,fill:BLUE},{idx:1,fill:ORANGE}]}]});
   }
   txt(s,'Association size: V = 0.275',42,611,573,29,21,true);
   txt(s,'Association size: V = 0.045',668,611,572,29,21,true);
  }else if(d.kind==='anova'){
   table(s,d.anova,42,165,1196,120,23,[830,183,183]);
   txt(s,'Education: existing survey groups.\nCRD: 32 randomized plots, 7 sulfur treatments.',42,299,593,60,21);
   txt(s,'Both tests detect a difference between means.\nF does not identify every differing pair.',668,299,569,60,21);
   rule(s,42,365);
   txt(s,'RBD: one blocking factor (rice)',42,383,570,32,24,true,BLUE);
   txt(s,'Latin Square: rows and columns',668,383,570,32,24,true,BLUE);
   chart(s,'line',d.rbd,27,436,354,184,{xAxis:{textStyle:{typeface:FONT,fontSize:15}},
    legend:{position:'right',textStyle:{typeface:FONT,fontSize:15}},
    yAxis:{min:4000,max:6000,majorUnit:1000,textStyle:{typeface:FONT,fontSize:15},majorGridlines:{fill:'#DFE7EB',width:1}}});
   table(s,d.rbd_table,402,438,213,110,19,[71,61,81]);
   txt(s,'6 rates in each block.\n44.8% lower error.',402,574,213,55,19,true);
   txt(s,'X: seeding rate (kg/ha). Y: yield (kg/ha). Rate p = 0.113.',42,615,573,22,16,false,MUTED);
   const grid=table(s,d.latin,669,436,272,178,21,undefined,false);
   const fills={A:'#E4F0F5',B:'#D0E4ED',C:'#176D8C',D:'#B9D6E2',E:'#EFF5F8'};
   for(let r=0;r<5;r++)for(let c=0;c<5;c++){const cell=grid.getCell(r,c);cell.fill=fills[d.latin[r][c]];cell.text.style={typeface:FONT,fontSize:21,bold:true,color:d.latin[r][c]==='C'?WHITE:INK,alignment:'center'};}
   txt(s,'Wheat: 5 treatments in a 5 × 5 grid. Each letter occurs once per row and column.',968,436,271,95,21);
   txt(s,'F = 21.03, p < 0.001',968,536,271,31,22,true,BLUE);
   txt(s,'C: highest mean, 13.12.\nWeekly dusting.',968,578,271,58,21,true);
  }
  box(s,42,646,1196,2,BLUE);txt(s,d.takeaway,42,658,1150,46,22,true,BLUE);
  txt(s,`${i} / ${D.requestedContentSlides}`,1192,691,69,22,14,false,MUTED);
 }
 s.speakerNotes.textFrame.setText(d.notes+'\n\nSources:\n'+Object.values(D.sources).join('\n')+'\nCalculations: matching saved R lab outputs. All29 original figures remain in the complete atlas.');
 console.log(`Authored ${i===0?'intro':`content ${i}`}: ${d.title}`);
}
const BUILD=path.join(ROOT,'.build/compact_presentation');await fs.mkdir(BUILD,{recursive:true});
const candidate=path.join(BUILD,'candidate.pptx');await(await PresentationFile.exportPptx(P)).save(candidate);
const FINAL=path.join(ROOT,'submission/Diabetes_Statistics_Presentation.pptx');
const receipt=path.join(ROOT,'.build/presentation/validation.json');
for(const file of [FINAL,receipt]){
 try{await fs.rename(file,path.join(BUILD,`previous-${Date.now()}-${path.basename(file)}`));}catch(e){if(e.code!=='ENOENT')throw e;}
}
const tables=[2,3,4,5,6,7,9,10,11,12],charts=[2,5,8,9,10,11,12];
await finalizePresentation({workspaceDir:ROOT,candidatePath:candidate,finalPath:FINAL,
 pythonExecutable:path.join(RT,'python/python.exe'),
 integrityValidatorPath:path.join(SKILL,'container_tools/inspect_presentation_package_integrity.py'),
 layoutValidatorPath:path.join(SKILL,'container_tools/inspect_presentation_layout_geometry.py'),
 layoutArgs:['--expected-slide-size-emu','12192000,6858000','--validate-heading-fit',...tables.flatMap(n=>['--require-native-table-slide',String(n)])],
 explicitTotalSlideCount:D.slides.length,requestedContentSlideCount:D.requestedContentSlides,
 requiredNativeTableOwnerSlides:tables,requiredNativeChartOwnerSlides:charts,
 materializeLiteralChartWorkbooks:true,fontPolicy:{basis:'design',families:[FONT]},verifyArtifactToolImport:true,receiptPath:receipt});
console.log('Finalized: one intro and twelve content slides.');
const verified=await PresentationFile.importPptx(await FileBlob.load(FINAL));
const previews=path.join(BUILD,'previews');await fs.mkdir(previews,{recursive:true});
for(let i=0;i<D.slides.length;i++){
 const blob=await verified.export({slide:verified.slides.items[i],format:'png',scale:1.25});
 await fs.writeFile(path.join(previews,`slide-${String(i+1).padStart(2,'0')}.png`),new Uint8Array(await blob.arrayBuffer()));
}
console.log('Rendered all 13 slides for review.');
