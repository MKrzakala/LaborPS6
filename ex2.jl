#Ex2
sigma_y_1=sqrt(0.38)
y_bar=1
gamma=0.96
sigma_epsilon=sqrt(0.045)
z=zeros(60)
z[1]=randn()*sigma_y_1+y_bar

for t in 1:59
    z[t+1]=gamma*z[t]+randn()*sigma_epsilon
end
plot(1:60,z[:])

#markov version
epsilon_value=deepcopy(sigma_epsilon)
function epsilon(rand)
    if rand < 0.5
        -epsilon_value
    else
        epsilon_value
    end
end

res=zeros(1000)
for i=1:1000
    res[i]=epsilon(rand())
end
std(res[:])

for t in 1:59
    z[t+1]=gamma*z[t]+epsilon(rand())
end
plot(1:60,z[:])
