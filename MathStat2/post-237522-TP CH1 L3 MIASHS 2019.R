#=======================================================================
#        NOTION DE CONVERGENCE/COURS STAT 2 2020-21
#                      L3 MIASHS
#=======================================================================

#EXERCICE 10.

#1. On sait que E(X)=(a+b)/2=1/2 et var(X)=(a-b)^2/12=1/12. 
#L'inegalite de Tchebychev donne donc dans ce cas : 
#   forall t>0, P(|X-0.5|>=t)<= 1/(12 t^2)
#2. On illustre ci-dessous cette egalite pour t=0.3. 
#   On approche P(|X-0.5|>=t) en calculant 
#   la proportion d'observation de X qui depassent l'esperance de 0.3
N=1000
esp.X=0.5
var.X=1/12
X=runif(N, min=0, max=1) #plot(density(X)) hist(X) pour voir l'allure de la loi

#Exemple
#proportion des observations de X a depasser l'esperance de 0.3
t=0.3
sum(as.numeric(abs(X-esp.X)>t))/N
#comparaison a var(X)/t^2
var.X/t^2

#3. Ci-dessous les codes qui illustrent l'inegalite pour plusieurs
#    valeurs de t. On observe que les majorations donnees par l'inegalite 
#    de Bienayme-Chebychev sont grossieres.
#    Mais l'aspect remarquable de cette inegalite est qu'elle est universelle
#    i.e., valable pour toute variable aleatoire 
#   (pour peu qu'elle admette une variance)
t=seq(from=0.01, to=1, by=0.01)
probas=NULL
for (i in 1:length(t)){
  probas=c(probas, sum(as.numeric(abs(X-esp.X)>t[i]))/N)
}
majorants=var.X/t^2
plot(t,majorants, type="l", ylim=c(0,1))
lines(t,probas, col="red",pch="+")

#=======================================================================
#EXERCICE 11

#Nous construisons le vecteur S qui recoit les valeurs sum_{k=1}^n 1/k^2
#n=1, ..., N, puis representons le nuage des points (n,S_n). 
#On calcule ensuite l'indice n_0 au dela duquel les points (n,S) sont
#dans le couloir de largeur eps autour de la limite l=pi^2/6.
#Ces points sont representes en bleu sur la figure.

N=100
n=1:N

#On fait une somme cumulee : on remarque qu'elle stagne
S=cumsum(1/n^2) 

#On se fixe la limite et epsilon
l=pi^2/6
eps=0.02

abline(h=pi^2/6, col='red') #ligne horizontale pi^2/6

#On trace (n,S) pour n=1, ..., N=100
plot(n,S, pch="+", cex=0.5, type="l", col='green', ylim=c(1, l+7*eps))

#On cherche le rang a partir duquel |S-l|<eps

n.0=n[min(which((abs(S-l)<eps)))]


abline(h=c(l,l-eps, l+eps), lty=c(1,2,2), col="red")
abline(v=n.0, col="blue")
points(n.0:N, S[n.0:N], col="blue", cex=0.5)

#=======================================================================
#EXERCICE 12  Convergence du minimum


#1. On génère N=100 v a uniformes sur (0,1) 
rm(list = ls()) #Effacer le memoire/passer par le balai

N=1000
X=runif(N, min=0, max=1) #plot(density(X)) hist(X) pour voir l'allure de la loi


#2.Simulation du Tn=min(U1, ..., Un)
for (n in 1:N)
   T[n]=min(X[1:n])

plot(1:N,T, type='l')

#eps=0.01
#abline(h=c(0,0, 0+eps), lty=c(1,2,2), col="red")
abline(h=0, col="blue")

#=======================================================================
#EXERCICE 13 Loi des grands nombres

#L'objet est d'illustrer le comportement de la moyenne, en fonction de
#la taille de l'echantillon. On va considerer : 
#X<-N(mu, sigma^2) et X<-Bernoulli (p)

n=1000

#Loi de Bernoulli
p=0.7
X1=rbinom(n,1,p) #on collecte les X1_i selon la loi de Bernoulli
#Vecteur collectant les moyennes cumulees
bar.X1=NULL
for (i in 1:n){
bar.X1=c(bar.X1, mean(X1[1:i]))
}
#On passe aux graphes/graphiques
par(mfrow=c(1,2)) #organisation des graphiques
plot(1:n, bar.X1, cex=0.3,main="Modèle de Bernoulli\n pour p=0.7",col.main= "blue") ; 
abline(h=p, col="red") #horizontale a mu=p=0.7, esperance de Bernoulli


#loi normale
n=300
mu=10
sigma=1
X2=rnorm(n,mean=mu, sd=sigma) #on collecte les X2_i selon la loi normale N(10,1)
bar.X2=NULL
for (i in 1:n){
  bar.X2=c(bar.X2, mean(X2[1:i]))
}
plot(1:n, bar.X2, cex=0.3, main="Modèle normal\n pour mu=10", col.main= "pink");
abline(h=10, col="red") #horizontale a mu=10











#=======================================================================
#EXERCICE 14 : Suites convergeant vers sigma^2

#Il est clair que S^2=n/(n-1) S'^2. Comme la variance echantillonnalle corrigee S^2 est donnée par la commande S^2=var() du logiciel R, 
#on peut ecrire les codes pour la variance empirique S'^2=mean(X-mean(X))^2 : biaise.

#Modèle de Bernoulli
n=30
p=0.7
X1=rbinom(n,1,p)
sigma.X1.2=p*(1-p) #Pour le modele de Bernoulli

#Modele gaussien
X2=rnorm(n,0,sd=1)
sigma.X2.2=1

#Modele de Student a df=5 ddl
X3=rt(n,df=5,1)
df=5
sigma.X3.2=df/(df-2) #Pour le modele de student a df ddl

#Remarque sur la loi de student
df=n=300
var(X3)*(n-1)/n
sigma.X3.2=df/(df-2) #Pour le modele de student a df ddl
sigma.X3.2


var.corr=NULL #S^2=var() sous R
var.emp=NULL  #S'^2
for (i in 2:n){
  var.corr=c(var.corr, var(X2[1:i]))
  var.emp=c(var.emp, ((i-1)/i)*var(X2[1:i]))
}
#Graphiques
par(mfrow=c(1,2))
plot(2:n, var.corr, type="l", main="S^2")
abline(h=sigma.X2.2, col="red")

plot(2:n, var.emp, pch=".", main="S'^2")
abline(h=sigma.X2.2, col="red")

MSE1=mean(var.corr-sigma.X2.2)^2
MSE2=mean(var.emp-sigma.X2.2)^2
#main=paste("MSE var.corr=", MSE1) 
print("MSE var.corr=") 
MSE1
print("MSE var.emp=") 
MSE2
#On compare var() et un programme de calcul de var corrigee
var(X1) # la commande sous R
1/(n-1)*sum((X1-mean(X1))^2) #estimateur corrige
1/(n)*sum((X1-mean(X1))^2) #estimateur corrige


















#=======================================================================
#EXERCICE 15 TCL

#Pour X suivant la loi U(0,1), on represente les distributions de 
#1000 valeurs de moyennes, d'echantillon de tailles n=5, 50, 100, la
#variable dans la population etant supposee suivre une loi uniforme.

K=1000 #nombre de valeurs pour representer les distributions
n=100 #valeur maximal de n
U=matrix(runif(K*n), ncol=n) #matrice des donnees simulees

par(mfrow=c(1,3))
#Loi de X
hist(U[1,], probability=TRUE, xlim=c(0,1), nclass=15, main ="Loi de X")

m=c(5,50, 100) #choix de n pour les representations
for (i in 1:length(m)){
  bar.U=apply(U[1:m[i],], FUN=mean, MARGIN=2) #appliquee aux colonnes
  hist(bar.U, probability = TRUE, xlim=c(0,1), nclass=15, main=paste("n=",m[i]),  ylim=c(-0.5, 15))
  grille.x=seq(range(U)[1], range(U)[2], by=0.01)
  lines(grille.x, dnorm(grille.x, mean=1/2, sd=sqrt(1/(12*n))), col="red", lwd=3)
}









#=======================================================================
#EXERCICE 16 : Approximation de la loi binomiale par la loi normale
#Theoreme de Moivre-Laplace

#On sait que si Xn suit B(n,p), on a E(X)=np et var(X)=np(1-p)
#On approche B(n,p) par N(np, np(1-p))
p=0.8
n=100
K=1000

par(mfrow=c(1,2))
Yn=rbinom(K,n,p)
range(Yn)

hist(Yn, probability = TRUE)
grille.x=seq(min(range(Yn)), max(range(Yn)), by=0.01)
lines(grille.x, dnorm(grille.x, mean=n*p, sd=sqrt(n*p*(1-p))), col="red", lwd=2)

Z.n=(Yn-n*p)/(sqrt(n*p*(1-p)))
grille.x=seq(-4,4, by=0.01)
hist(Z.n, probability=TRUE)
#lines(density(Z.n), col='blue') #est une estimation de la densite de probabilite de Z.n
lines(grille.x, dnorm(grille.x, 0,1), type='l', col="red")





