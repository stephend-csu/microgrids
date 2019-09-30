% load driving cycle
load JN1015

% create grid
clear grd
grd.Nx{1}    = 61; 
grd.Xn{1}.hi = 0.7; 
grd.Xn{1}.lo = 0.4;

grd.Nu{1}    = 21; 
grd.Un{1}.hi = 1; 
grd.Un{1}.lo = 0;	% Att: Lower bound may vary with engine size.

% set initial state
grd.X0{1} = 0.69;

% final state constraints
grd.XN{1}.hi = 0.55;
grd.XN{1}.lo = 0.54;


% define problem
clear prb
prb.W{1} = PVprofile_vector; % (255601 elements)
prb.W{2} = Totalloadprofile_vector; % (255601 elements)
prb.Ts = 1;
prb.N  = 255600*1/prb.Ts + 1;

% set options
options = dpm();
options.MyInf = 1000;
options.BoundaryMethod = 'Line'; % also possible: 'none' or 'LevelSet';
if strcmp(options.BoundaryMethod,'Line') 
    %these options are only needed if 'Line' is used
    options.Iter = 5;
    options.Tol = 1e-8;
    options.FixedGrid = 0;
end
[res, dyn] = dpm(@hev3,[],grd,prb,options);
