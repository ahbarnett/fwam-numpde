% high-order polynomial fit demo: choice of nodes. Barnett 10/25/19
clear
%f = @(x) sin(5*x+1);      % the func: entire, works fine
f = @(x) 1./(1+9*x.^2);    % the func: nearby singularities, causes unif to fail
n=32;                      % degree
t=linspace(-1,1,1e3);      % fine plotting grid
for fig=1:2
  figure(fig); clf;
  if fig==1, x=linspace(-1,1,n); %x = 2*rand(1,n)-1; x(1)=-1; x(1)=1;
  else, x = -cos(pi*(0.5:n-.5)/n); x = -cos(pi*(0:n-1)/(n-1));
  end
  V = ones(n,n); for k=2:n, V(:,k) = V(:,k-1).*x'; end  % Vandermonde
  y = f(x);     % node data
  c = V\y(:);   % get poly coeffs the cheap way (barycentric Lagrange similar)
  ft = f(t);
  subplot(2,1,1); plot(t,ft,'b-'); hold on;
  ff = polyval(c(end:-1:1), t);   % eval the poly on fine grid
  e = max(abs(ff-ft))
  plot(t, ff, 'r-');
  plot(x,y,'k.','markersize',10);
  axis([-1 1 0*min(ft) 1.1*max(ft)]);
  if fig==1, title('uniform nodes: $\;\; x_j = 2(j-1)/(N-1)-1$','interpreter','latex');
  else, title('Chebychev nodes: $\;\; x_j = \cos \pi(j-1)/(N-1)$','interpreter','latex'); end
  subplot(2,1,2); plot(t,ff-ft,'b-'); hold on;
  plot(x,0*y,'k.','markersize',10);
  axis tight; title('error $\;\; \tilde f(x) - f(x)$','interpreter','latex')
  if fig==1, text(-.8,2,'bad','color',[1 0 0]);
    text(.7,2,'bad','color',[1 0 0]); text(-.1,2,'okay','color',[0 0 1]); end
  set(gcf,'paperposition',[0 0 4 3]);
  print('-dpng',sprintf('../figs/demopoly%d.png',fig));
end
