#Ex 1

using CSV
using DataFrames
using Plots

df=DataFrame(CSV.File("lifetable_m.csv"))
plot(df[:,1],df[:,2])
df1=Matrix(df)

91-24
mu=zeros(67)
n=0.02
mu[1]=1
for t in 1:66
    mu[t+1]=mu[t]*(1-df1[(25+t),2])/(1+n)
end
sum_mu=sum(mu[:])
mu[1]=1/sum_mu
for t in 1:66
    mu[t+1]=mu[t]*(1-df1[(25+t),2])/(1+n)
end
sum(mu[:])
plot(1:67,mu[:])
mu_1=deepcopy(mu)

#now for different n:
n=0.01
mu[1]=1
for t in 1:66
    mu[t+1]=mu[t]*(1-df1[(25+t),2])/(1+n)
end
sum_mu=sum(mu[:])
mu[1]=1/sum_mu
for t in 1:66
    mu[t+1]=mu[t]*(1-df1[(25+t),2])/(1+n)
end
sum(mu[:])
mu_2=deepcopy(mu)

plot(1:67,mu_1[:], label="n=0.02")
plot!(1:67,mu_2[:], label="n=0.01")

