
function [X, C, I, out] = hev3(inp,par)
%function [X C I out] = hev(inp,par)
%mic1 Computes the resulting state-of-charge based on current state-
%   of-charge, inputs and disturbances.
%   
%   [X C I out] = hev1(INP,PAR)
%
%   INP   = input structure
%   PAR   = user defined parameters
%
%   X     = resulting state-of-charge
%   C     = cost matrix
%   I     = infeasible matrix
%   out   = user defined output signals

%Battery  power
Pl=inp.W{2};
Ppv=inp.W{1};
Pg=(1-inp.U{1}).*(inp.W{2}-inp.W{1});
Pe =inp.U{1}.*(inp.W{2}-inp.W{1});
% BATTERY
% state-of-charge list
% soc_list = [0 0.2 0.4 0.6 0.8 1];
% discharging resistance (indexed by state-of-charge list)
% R_dis    = [1.75    0.60    0.40    0.30    0.30    0.30]; % ohm
% % charging resistance (indexed by state-of-charge list)
% R_chg    = [0.35    0.50    0.85    1.00    2.00    5.00]; % ohm
% open circuit voltage (indexed by state-of-charge list)
% V_oc     = [230     240     245     250     255     257]; % volt

% Battery efficiency
% columbic efficiency (0.9 when charging)
e = (Pe>0) + (Pe<=0) .* 0.9;
% Battery internal resistance
% r = (Pm>0)  .* interp1(soc_list, R_dis, inp.X{1},'linear*','extrap')...
%   + (Pm<=0) .* interp1(soc_list, R_chg, inp.X{1},'linear*','extrap');

% Battery current limitations
%   battery capacity            = 750Ah 
%   maximum discharging current = 100A
%   maximum charging current    = 125A
%   battery current
% ib = (Pm>0) .* 100 + (Pm<=0) .* 125;
% Battery voltage= 230 V
Vb = 400;
% Battery current
Ib  =   (Pl-Ppv-Pg)/Vb;
% New battery state of charge
X{1}  = - Ib.*e / (750*3600) + inp.X{1};
% Battery power(KW) consumption
Pb =   Ib .* Vb;
% Update infeasible 
% Pb<=Pm;
% Pg>0;

% Ppv>=0;
% Ib>=ib;
% Set new state of charge to real values
X{1} = (conj(X{1})+X{1})/2;
Pb   = (conj(Pb)+Pb)/2;
Ib   = (conj(Ib)+Ib)/2;
% COST
% Summarize infeasible matrix
I = (Pl-Ppv-Pe-Pg~=0);
% Calculate cost matrix
%cost of electricity per kilowatthour=C1
% Total energy consumed in kilowatthour=Epg
% Epg = Pg.*(1/3600); %in KWh
% C1=0.55;% $/KWh
%  C{1}= Epg.*C1;
if Pg{1}<=500
     c1=0.85;
     C1=Pg.*c1;
     
end 
C{1}=C1;
% if Pg{1}>500 
%      c2=3.00;
%      C2{2}=Pg.*c2;
% end     
% if Pg{1}>=1500
%      c3=6.00;
%      C3{3}=Pg.*c3;
% end    
% C{1}=C1{1}+C2{1}+C3{1};

% SIGNALS
%   store relevant signals in out
out.Ib = Ib;
out.Pb = Pb;
out.Pg = Pg;
out.Pe = Pe;
out.C1 =C1;
% out.C2 =C2;
% out.C3 =C3;
out.Epg=Epg;


% REVISION HISTORY
% =========================================================================
% DATE      WHO                 WHAT
% -------------------------------------------------------------------------
% 





