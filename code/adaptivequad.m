function adaptivequad(tol)
% demo adaptive quadrature with Clenshaw-Curtis panels.
% needs clencurt.m. Barnett 5/20/13 from dartmouth/M56/lec17
% Reused for adaptivity idea in interp.

f = @(x) 1+sin(9.9*erf(20*x));    % no exact integral known.

t = linspace(0,1,1e3);
figure; plot(t,f(t),'k-'); set(gcf,'paperposition',[0 0 7 1.5]);
text(0.07,1.5,'$f(x)$','interpreter','latex');
h=[text(0,0.3,'local rapid change, wacky','color',[1 0 0])...
   text(0.5,0.3,'big region of smooth, boring')...  % (few nodes needed)')...
   text(0.18,1.5,'Say want to interpolate (approximate) to user tolerance, eg $\epsilon=10^{-12}$','interpreter','latex')...
];
print -depsc2 ../figs/adap1.eps

[Ia fevals] = adaptiveCCquad(f,0,1, 1e-12)
delete(h)
text(0.05,0.3,'small panels');
text(0.6,0.3,'big panels');
text(0.2,1.5,'each ``panel" is its own $p=16$ Chebychev grid','interpreter','latex');
print -depsc2 ../figs/adap2.eps

%fprintf('err = %.3g\n',Ia-I)

end

function [I fevals] = adaptiveCCquad(fun,a,b,tol,s)
% recursive adaptive quadrature with Clenshaw-Curtis panels.
% s is a structure that contains nodes and weights for n=9,17.

n = 9; n2 = 17;              % CC orders for coarse and fine nodes
if nargin<5        % fill s structure with node and weights so don't recompute
  [s.x s.w]  = clencurt(n-1);        % N=9
  [s.x2 s.w2]  = clencurt(n2-1);   % N=17
end
mid = (a+b)/2; siz = (b-a)/2;
x2 = mid + siz*s.x2;         % scale fine nodes for this panel
w = siz*s.w; w2 = siz*s.w2;  % scale weights

f2 = fun(x2);  f = f2(1:2:end);      % get f at the 2 node sets (one is subset)
I = dot(f,w); I2 = dot(f2,w2);
if abs(I2-I) < tol             % criterion for splitting
  %plot(x2, w2/siz, 'r.'); hold on;   % show the nodes used
  plot(x2, f2, 'k.','markersize',10); hold on;  % show the func at the nodes used
  plot([a a],[0 f2(1)],'b-'); plot([b b],[0 f2(end)],'b-'); 
  I = I2; fevals = n2;                   % use the most accurate
  return
else                         % split and recurse...
  [Il fevalsl] = adaptiveCCquad(fun,a,mid,tol,s);
  [Ir fevalsr] = adaptiveCCquad(fun,mid,b,tol,s);
  I = Il + Ir;
  fevals = fevalsl + fevalsr;  % keep track of how many func evals used
end
  
end
