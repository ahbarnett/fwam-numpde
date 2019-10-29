% demo error of finite differencing for f' as function of h. Barnett 10/29/19
clear
f = @(x) tan(x);                   % func to test
fp = @(x) 1./cos(x).^2;            % its analytic deriv
x0 = 1.1;                          % ordinate to test finding f' at
hs = logspace(-16,0,100);          % range of spacings h
es = nan*hs;
for i=1:numel(hs), h = hs(i);
  fd = (f(x0+h)-f(x0-h))/(2*h);    % centered difference formula
  es(i) = fp(x0) - fd;
end
figure; loglog(hs,abs(es),'+-');
hold on;
plot(hs,eps./hs,'r--');            % model catastrophic cancellation error
text(1e-13,1e-1,'slope = -1','interpreter','latex','color',[0.8 0 0]);
plot(hs,hs.^2,'g--');              % formula is O(h^2) in exact arith
text(1e-5,1e-1,'slope = 2','interpreter','latex','color',[0 0.8 0]);
text(1e-5,1e-2,'$O(h^2)$','interpreter','latex','color',[0 0.8 0]);
xlabel('$h$','interpreter','latex');
ylabel('error   $|f''(x) - \frac{f(x+h)-f(x-h)}{2h}|$','interpreter','latex');
axis([min(hs) max(hs) 1e-11 10]);
set(gcf,'paperposition',[0 0 5 3]);
print -depsc2 ../figs/fderr.eps
