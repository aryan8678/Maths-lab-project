# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 2: tabulation and graphical representations
out <- lab_output("Lab02_Summary_Stats"); df <- load_clean()
numeric_vars <- c("BMI","MentHlth","PhysHlth")
tab <- do.call(rbind,lapply(numeric_vars,function(v){x<-df[[v]]; data.frame(variable=v,n=length(x),
 mean=mean(x),median=median(x),sd=sd(x),variance=var(x),min=min(x),q1=quantile(x,.25),q3=quantile(x,.75),max=max(x),iqr=IQR(x))}))
csv(tab,file.path(out,"numeric_summary.csv"))
csv(group_summary(df$BMI,df$Diabetes_012),file.path(out,"bmi_by_status.csv"))
frequency <- function(v) data.frame(variable=v,category=names(table(df[[v]])),count=as.numeric(table(df[[v]])),proportion=as.numeric(prop.table(table(df[[v]]))))
csv(do.call(rbind,lapply(c("Diabetes_012","Diabetes_binary","Sex","Education","HighBP","Smoker","PhysActivity"),frequency)),file.path(out,"frequencies.csv"))
histogram <- hist(df$BMI,breaks=seq(0,100,2),plot=FALSE)
csv(data.frame(mid=histogram$mids,count=histogram$counts),file.path(out,"bmi_histogram.csv"))
draw(file.path(out,"hist_bmi.png"),hist(df$BMI,breaks=seq(0,100,2),col=blue,border="white",main="Distribution of BMI",xlab="BMI (kg/m^2)"))
draw(file.path(out,"bar_education.png"),{
 par(mar=c(8,5,3,1)); barplot(table(df$Education),col=blue,las=2,ylab="Respondents",main="Education in the working sample")
})
draw(file.path(out,"pie_sex.png"),pie(table(df$Sex),col=c(blue,orange),main="Sex distribution"))
draw(file.path(out,"box_bmi_by_diabetes.png"),boxplot(BMI~Diabetes_012,data=df,col=c(blue,teal,orange),ylab="BMI (kg/m^2)",main="BMI by three-class health status"))
draw(file.path(out,"density_bmi.png"),{
 plot(density(df$BMI),col=blue,lwd=3,main="BMI density",xlab="BMI (kg/m^2)"); rug(df$BMI,col=adjustcolor(blue,.1))
})
days <- as.numeric(table(factor(df$PhysHlth,levels=0:30)))
csv(data.frame(day=0:30,count=days),file.path(out,"phys_days.csv"))
draw(file.path(out,"bar_phys_days.png"),barplot(days,names.arg=0:30,col=blue,ylab="Respondents",xlab="Poor physical health days in past 30 days",main="PhysHlth is a bounded count"))
log_text(file.path(out,"lab02_summary_stats.txt"),{print(tab); print(table(df$Diabetes_012)); cat("Count plots preserve the 0 and 30 day endpoints.\n")})
