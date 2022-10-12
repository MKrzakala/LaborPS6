using Plots
using Statistics
using DataFrames
using CSV
using LinearAlgebra

const sigma = 2
const beta = 0.9
const r = 1/beta-1
global wvector=[0.5 0.5 0.75 0.75 1 1 0.75 0.75 0.25 0.25]
const T = 10
const n = 300

V=zeros(n,T)
g=zeros(n,T-1)
A = LinRange(0, 1, n)

function u(c)
    if sigma==1
        log(c)
    else
        c^(1-sigma)/(1-sigma)
    end
end

#generate shocks
z=randn(10).*0.05.+1


#consumption given a is in last period just a + wage
C=A.+wvector[T]
#same goes for utility in last period, as well as value function
U=broadcast(u,C)
V[:,T]=U

for i=1:(T-1)
    #total income 
    I=A.+wvector[T-i]
    I=Transpose(I*ones(1,n))
    C=I-(A*ones(1,n))/(1+r)
    U=ones(n,n)*(-10000)

    for j=1:n
        for k=1:n
            if C[j,k]>0
                U[j,k]=u(C[j,k])
            end
        end
    end
    to_max=(U+beta*V[:,T-i+1]*ones(1,n))
    Vmax, gmax =findmax(to_max, dims=1)
    some_index=zeros(n)
    gmax_tup=Tuple.(gmax[1,:])
    for idx=1:n
        (g[idx,T-i],some_index[idx])=gmax_tup[idx]
        g[idx,T-i]=floor(Int, g[idx,T-i])
    end
    V[:,T-i]=Transpose(Vmax)
end

savingdec=zeros(T,1)
assetlevel=zeros(T,1)
assetlevelindex=1  

for i=1:(T-1)     
    savingdec[i]=A[floor(Int, g[assetlevelindex,i])]
    assetlevelindex=floor(Int, g[assetlevelindex,i])
    assetlevel[i+1]=A[assetlevelindex]
end

results=DataFrame(Age=1:T, Asset=assetlevel[:], Asset_plus_wage=(assetlevel.+Transpose(wvector))[:], Savings=savingdec[:], Consumption=(assetlevel+Transpose(wvector)-savingdec)[:])
results.Consumption
plot(1:T,wvector[:], label="Income", title="wages and the optimal consumption decision", xaxis="age")
plot!(1:T,results.Consumption, label="Consumption")