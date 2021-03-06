function [Xt, Pt, g, M] = mulcycussmthwcv(xx, y, pfix, pvar, xf, stordt, conc, n, r, l, idatei)
%*************************************************************************
% Auxiliary function called in mulcycuswvc_d.m.
%
%       This function applies to the series y the two stage Kalman filter
%       for smoothing corresponding to the model
%
%       y_t = X_t*beta + Z_t*alpha_t + G_t*epsilon_t
%       alpha_{t+1}= W_t*beta + T_t*alpha_t + H_t*epsilon_t,
%
%       where epsilon_t is (0,sigma^2I),
%
%       with initial state
%
%       alpha_1= c + W_0*beta + a_1 + A_1*delta
%
%       where c is (0,Omega) and delta is (0,kI) (diffuse). A single
%       collapse is applied to get rid of the diffuse component.
%
% INPUTS:
%         y : an (n x p) matrix of observations
%        xx : array with parameters to be estimated
%      pfix : array with fixed parameter indices
%      pvar : array with variable parameter indices
%        xf : array with fixed parameters
%    stordt : array with indices for standard deviations
%      conc : index for the standard deviation to be concentrated out
%         n : number of variables in the data matrix y
%         r : number of slope factors
%         l : numbef of quarterly series
%    idatei : calendar structure to set up cumulator variable (not used)
%
% OUTPUTS:
%        Xt : an (n x nalpha) matrix containing the estimated x_{t|n}
%        Pt : an (n*nalpha x nalpha) matrix containing the
%              Mse of x_{t|n}
%        g  : the beta estimator
%        M  : the Mse of the beta estimator
%
% Copyright (c) 21 July 2003 by Victor Gomez
% Ministerio de Hacienda, Direccion Gral. de Presupuestos,
% Subdireccion Gral. de Analisis y P.E.,
% Alberto Alcocer 2, 1-P, D-34, 28046, Madrid, SPAIN.
% Phone : +34-915835439
% E-mail: VGomez@sepg.minhap.es
%
% The author assumes no responsibility for errors or damage resulting from the use
% of this code. Usage of this code in applications and/or alterations of it should
% be referenced. This code may be redistributed if nothing has been added or
% removed and no money is charged. Positive or negative feedback would be appreciated.
%
%*************************************************************************

models = modstr_mulcycuswcv(xx, pfix, pvar, xf, stordt, conc, n, r, l);
Z = models.Z;
T = models.T;

% %include cumulator variables in T (T is time-varying)
% [ny,my]=size(y);
% TT=repmat(T,ny,1);
% initper=idatei.beg_per;
% freq=idatei.freq;
% npr=n+r; nprpl=npr+l;
% [nt,mt]=size(T);
% for i=initper:initper+ny
%  if mod(i+1,freq)== 1
%   j=i-initper+1; nn=nt*(j-1)+npr;
%   TT(nn+1:nn+l,npr+1:end)=eye(l);
%  end
% end

G = models.G;
H = models.H;
W = models.W;
X = models.X;
ins = models.ins;
i = models.i;

% [Xt,Pt,g,M]=scakfs(y,X,Z,G,W,T,H,ins,i);
[Xt, Pt, g, M] = scakfssqrt(y, X, Z, G, W, T, H, ins, i);
