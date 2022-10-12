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
global z_levels=2


V=zeros(n,T,z_levels)
g=zeros(n,T-1,z_levels)
A = LinRange(0, 1, n)
A=ones(n,z_levels).*A

function u(c)
    if sigma==1
        log(c)
    else
        c^(1-sigma)/(1-sigma)
    end
end

#generate shocks
epsilon_value=0.05
mu_value=1
function epsilon(rand)
    if rand < 0.5
        mu_value-epsilon_value
    else
        mu_value+epsilon_value
    end
end

function epsilon_idx(rand)
    if rand < 0.5
        1
    else
        2
    end
end

z=broadcast(epsilon, rand(10))
z_idx=broadcast(epsilon_idx, rand(10))

sigma_z=0.025
z_l=1*(1+sigma_z)
z_h=1*(1-sigma_z)
levels_z=[z_l;z_h]
#consumption given a and z is in last period just a + wage(and shock)
C=[wvector[T].*ones(n,1)*(z_l) wvector[T].*ones(n,1)*(z_h)] 
C=A.+C
#same goes for utility in last period, as well as value function
U=broadcast(u,C)
V[:,T,:]=U

i=1
I_choice=zeros(n,n,z_levels)
C_choice=zeros(n,n,z_levels)
U_choice=zeros(n,n,z_levels)
to_max=zeros(n,n,z_levels)
for i=1:(T-1)
    #total income 
    z_lev=1
    for z_lev=1:z_levels
        I=A[:,z_lev]+wvector[T-i]*ones(n,1)*levels_z[z_lev]
        I_choice[:,:,z_lev]=Transpose(I[:]*ones(1,n))
        C_choice[:,:,z_lev]=I_choice[:,:,z_lev]-(A[:,z_lev]*ones(1,n))/(1+r)
        U_choice[:,:,z_lev]=ones(n,n)*(-10000)
        for j=1:n
            for k=1:n
                if C_choice[j,k,z_lev]>0
                    U_choice[j,k,z_lev]=u(C_choice[j,k,z_lev])
                end
            end
        end
        to_max[:,:,z_lev]=(U_choice[:,:,z_lev]+beta*(0.5*V[:,T-i+1,1]*ones(1,n))+0.5*V[:,T-i+1,2]*ones(1,n))
        Vmax, gmax =findmax(to_max[:,:,z_lev], dims=1)
        some_index=zeros(n)
        gmax_tup=Tuple.(gmax[1,:])
        for idx=1:n
            (g[idx,T-i,z_lev],some_index[idx])=gmax_tup[idx]
            g[idx,T-i,z_lev]=floor(Int, g[idx,T-i,z_lev])
        end
        V[:,T-i,z_lev]=Transpose(Vmax)
    end
end

V[:,10,1]
savingdec=zeros(T,1,10)
assetlevel=zeros(T,1,10)
assetlevelindex=1  
z_paths=zeros(10,T)
c_paths=zeros(10,T)
for n=1:10
    z_paths[n,:]=broadcast(epsilon_idx, rand(10))
end
for n=1:10
    for i=1:(T-1)     
        savingdec[i,1,n]=A[floor(Int, g[assetlevelindex,i,floor(Int,z_paths[n,i])]),1]
        c_paths[n,i]=A[assetlevelindex,1]+wvector[i]*levels_z[floor(Int,z_paths[n,i])]-savingdec[i,1,n]
        assetlevelindex=floor(Int, g[assetlevelindex,i,floor(Int,z_paths[n,i])])
        assetlevel[i+1,1,n]=A[assetlevelindex]
    end
    c_paths[n,10]=A[assetlevelindex,1]+wvector[10]*levels_z[floor(Int,z_paths[n,10])]
end

plot(1:10,c_paths[1,:])
plot!(1:10,c_paths[2,:])
plot!(1:10,c_paths[3,:])
plot!(1:10,c_paths[4,:])
plot!(1:10,c_paths[5,:])
plot!(1:10,c_paths[6,:])
plot!(1:10,c_paths[7,:])
plot!(1:10,c_paths[8,:])
plot!(1:10,c_paths[9,:])
plot!(1:10,c_paths[10,:])




