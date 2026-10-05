# Presentation-sized drawings from the same prepared data and fitted models.
# Original lab drawings stay in the complete figure atlas.
source('R/common.R')
df <- load_clean(); filtered <- load_clean(TRUE)
pitch <- file.path(root,'.build','pitch_figures');dir.create(pitch,recursive=TRUE,showWarnings=FALSE)
plot_pitch <- function(name,w,h,code) {
 png(file.path(pitch,paste0(name,'.png')),width=2*w,height=2*h,res=144,pointsize=18,bg='white')
 on.exit(dev.off(),add=TRUE)
 par(family='sans',mar=c(3.5,3.7,.6,.6),mgp=c(2,.6,0),cex.axis=.9,las=1,col.axis='#344456',col.lab='#183044')
 force(code)
}
plot_pitch('bmi_fences',686,418,{
 hist(df$BMI,breaks=seq(10,100,2),col=blue,border='white',main='',xlab=expression(BMI~(kg/m^2)),ylab='People',xlim=c(10,90))
 abline(v=c(13.5,41.5),col=orange,lwd=3,lty=2)
 text(41.5,par('usr')[4]*.87,'41.5',pos=4,col=orange,cex=1)
})
plot_pitch('before_after',500,260,{
 boxplot(df$BMI,filtered$BMI,names=c('Before','After'),col=c(blue,teal),ylab='BMI',main='')
})
plot_pitch('density',370,230,{
 plot(density(df$BMI),col=blue,lwd=3,main='',xlab='BMI',ylab='Density',xlim=c(10,90))
})
plot_pitch('scatter',724,354,{
 plot(df$PhysHlth,df$BMI,pch=16,col=adjustcolor(blue,.18),cex=.6,xlab='Poor physical-health days',ylab='BMI',main='')
 abline(lm(BMI~PhysHlth,data=df),col=orange,lwd=3)
})
plot_pitch('status_box',450,287,{
 boxplot(BMI~Diabetes_012,data=df,col=c(blue,teal,orange),ylab='BMI',xlab='',main='',names=c('No diabetes','Prediabetes','Diabetes'),cex.axis=.8)
})
plot_pitch('normal',370,258,{
 hist(df$BMI,breaks=seq(10,100,2),probability=TRUE,col=blue,border='white',main='',xlab='BMI',ylab='Density')
 curve(dnorm(x,mean(df$BMI),sd(df$BMI)),add=TRUE,col=orange,lwd=3)
})
model <- lm(BMI~Age+PhysActivity+Income+Education+Smoker,data=transform(df,
 Age=relevel(Age,'50-54'),Income=relevel(Income,'35-50k'),Education=relevel(Education,'High school')))
plot_pitch('diagnostics',658,404,{
 par(mfrow=c(2,2),mar=c(2.6,3,1.1,.6),mgp=c(1.5,.4,0),cex=.87)
 plot(model,which=c(1,2,3,5),ask=FALSE,id.n=0,caption=c('Residuals and fitted values','Normal Q-Q','Changing spread','Influence'))
})
cat('Prepared seven compact, legible drawings for the presentation.\n')
