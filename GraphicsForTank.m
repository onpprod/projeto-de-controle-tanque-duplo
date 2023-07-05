% CORES
black = [40/255,50/255,20/255]; % Cor preta para os gráficos
blue = [36/255,51/255,130/255]; % Cor azul para os gráficos
orange = [240/255,150/255,50/255]; % Cor laranja para os gráficos
green = [100/255,200/255,100/255]; % Cor verde para os gráficos
red = [225/255 0/255 10/255]; % Cor vermelha para os gráficos 
purple = [255/255 102/255 178/255]; % Cor roxa para os gráficos 
% CONFIGURAÇÕES

esp = 1.5; %espessura da linha
tit = 24; %Fonte do título
leg = 14; %Fonte da legenda
mar = 22; %Fonte das marcações
eix = 22; %Fonte dos eixos

% Simulação do gráfico via script
step=0.1;                       % passo da simulação
t = 0:step:1000;                %vetor de tempo
A=0.00012133;                   %valor da área da sessão transversal do tanque
a=1.978e-6;                     %valor da área da sessão transversal da vávula
g=9.8;%gravidade
u0=a*sqrt(2*g*0.11);            %calculo para definição de fluxo apropriado para nivel especificado - nive 0.11 metros
u1 = u0*ones(1,length(t));      %criar vetor que será o sinal de entrada - (fluxo de alimentação)
y1(1)=0;                        %criar vetor de sinal de saida com primera posição nula
y2(1)=0;
KEY=false;

%chave de adição de nivel pós acomodação
for i=1:(length(t)-1)
    if i>6000 && KEY==false                     % condição que verifica se chave ativa da linha 23 e tempo atigindo aplica um fluxo adicional
        u1(i)=a*sqrt(2*g*(0.11+0.011));         %adição de 11mm em 11cm
    end
k_1=tankup(y1(i),u1(i));                        %aplica a função tanque para calcular o fluxo momentaneo 
k_2=tankup(y1(i)+0.5*k_1,u1(i));
k_3=tankup(y1(i)+0.5*k_2,u1(i));
k_4=tankup(y1(i)+k_3,u1(i));

y1(i+1)=y1(i)+(1/6)*(k_1+2*k_2+2*k_3+k_4)*step; % vetor de saida com o processamento de dados 
end



% GRÁFICO 1
figure()
hold on
plot(t,y1,'color',black,'linewidth',esp)%plota o gráfico de saida
hold off
set(gca,'fontsize',mar,'ticklabelinterpreter','latex')
xlabel('Tempo - (segundos)','fontsize',eix,'interpreter','latex')
ylabel('Altura - (m)','fontsize',eix,'interpreter','latex')
title('Saida','fontsize',tit,'interpreter','latex')
%legend({'$X_1(t)$','$X_2(t)$'},'fontsize',leg,'interpreter','latex',...
    %    'orientation','horizontal')
grid on, grid minor
% GRÁFICO 2
figure()
ylim([10^-6 4*10^-6])%ajusta a escala do eixo y para valos correspondentes as potências
hold on
plot(t,u1,'color',red,'linewidth',esp)%plota o gráfico de entrada
hold off
set(gca,'fontsize',mar,'ticklabelinterpreter','latex')
xlabel('Tempo - (segundos)','fontsize',eix,'interpreter','latex')
ylabel('Volume de vaz\~ao - (m$^3$)','fontsize',eix,'interpreter','latex')
title('Entrada','fontsize',tit,'interpreter','latex')
%legend({'$X_1(t)$','$X_2(t)$'},'fontsize',leg,'interpreter','latex',...
%        'orientation','horizontal')
grid on, grid minor