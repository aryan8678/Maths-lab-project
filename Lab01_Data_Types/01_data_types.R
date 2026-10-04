# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 1: validation, typing, import and export
out <- lab_output("Lab01_Data_Types")
df <- read.csv(data_path("brfss_sample.csv"))
binary <- c("Diabetes_binary","HighBP","HighChol","CholCheck","Smoker","Stroke",
 "HeartDiseaseorAttack","PhysActivity","Fruits","Veggies","HvyAlcoholConsump",
 "AnyHealthcare","NoDocbcCost","DiffWalk","Sex")
allowed <- c(setNames(rep(list(0:1),length(binary)),binary),
 list(Diabetes_012=0:2,GenHlth=1:5,Education=1:6,Income=1:8,Age=1:13,MentHlth=0:30,PhysHlth=0:30))
bad <- matrix(FALSE,nrow(df),length(allowed)+1, dimnames=list(NULL,c(names(allowed),"BMI")))
for (v in names(allowed)) bad[,v] <- is.na(df[[v]]) | !(df[[v]] %in% allowed[[v]])
bad[,"BMI"] <- !is.finite(df$BMI) | df$BMI <= 0
invalid <- rowSums(bad)>0
ledger <- data.frame(source_row=df$source_row[invalid],
 reason=apply(bad[invalid,,drop=FALSE],1,function(x) paste(colnames(bad)[x],collapse=", ")))
csv(ledger,file.path(out,"invalid_records.csv"))
csv(data.frame(variable=names(df),missing=sapply(df,function(x)sum(is.na(x)))),file.path(out,"missingness.csv"))
original_n <- nrow(df); df <- df[!invalid,]
for(v in setdiff(binary,"Sex")) df[[v]] <- factor(df[[v]],levels=0:1,labels=c("No","Yes"))
df$Sex <- factor(df$Sex,levels=0:1,labels=c("Female","Male"))
df$Diabetes_012 <- factor(df$Diabetes_012,levels=0:2,labels=c("No diabetes","Prediabetes","Diabetes"))
df$Age <- factor(df$Age,levels=1:13,labels=c("18-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79","80+"))
df$GenHlth <- factor(df$GenHlth,levels=1:5,labels=c("Excellent","Very good","Good","Fair","Poor"),ordered=TRUE)
df$Education <- factor(df$Education,levels=1:6,labels=c("No school","Elementary","Some high school","High school","Some college","College graduate"))
df$Income <- factor(df$Income,levels=1:8,labels=c("<10k","10-15k","15-20k","20-25k","25-35k","35-50k","50-75k","75k+"))
stopifnot(!anyNA(df))
types <- vapply(names(df),function(v) if(v=="source_row") "Source row identifier" else if(v=="Diabetes_012") "Categorical status with 3 levels" else if(v %in% binary) "Binary nominal" else if(v=="BMI") "Continuous measure recorded as integer" else if(v %in% c("MentHlth","PhysHlth")) "Bounded count 0-30 days" else "Ordinal category",character(1))
csv(data.frame(variable=names(df),type=types,R_class=sapply(df,function(x)paste(class(x),collapse=", "))),file.path(out,"variable_dictionary.csv"))
saveRDS(df,data_path("brfss_clean.rds")); csv(df,data_path("brfss_clean.csv"))
metrics(c(original_n=original_n,invalid_n=sum(invalid),clean_n=nrow(df),missing_cells=sum(is.na(df))),out)
log_text(file.path(out,"lab01_variable_types.txt"),{
 cat("RDS preserves factors; CSV is for exchange. Ordinal predictors use categorical contrasts in regression.\n")
 cat("Rows before:",original_n,"Invalid removed:",sum(invalid),"Rows retained:",nrow(df),"\n")
 str(df); print(types)
})
