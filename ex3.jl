using Plots
using Statistics
using DataFrames
using CSV

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


#consumption given a is in last period just a + wage
C=A.+wvector[T]
#same goes for utility in last period, as well as value function
U=broadcast(u,C)
V[:,T]=U

#Finished worked here
#what to do is to replicate the loop for deterministic case
#save the policy functions and consumption path
#apply for stochastic environment

for i=1:(T-1)
    I=