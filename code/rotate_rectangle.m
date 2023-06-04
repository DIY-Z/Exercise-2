x_left = 3;
xc = 1;
height = 2;
mass_height_diff = 5;
w_chassis = 1;
height = 5;

x = [x_left
    w_chassis+1];
y = [xc-height/2+2*mass_height_diff
    height];
h = plot([x(1) x(2) x(2) x(1) x(1)],...
    [y(1) y(1) y(2) y(2) y(1)]);
rotate(h,[0 0 1],45)

% x = [x_left
%     w_chassis+1];
% y = [xc-height/2+2*mass_height_diff
%     height];
% x = x([1 2 2 1 1]);
% y = y([1 1 2 2 1]);
% a = 15;
% R = [cosd(a) -sind(a);sind(a) cosd(a)];       % rotation matrix
% v = R*[x(:)-mean(x) y(:)-mean(y)]'; % center and rotate rectangle
% x = v(1,:)+mean(x);                 % restore original position
% y = v(2,:)+mean(y);
% plot(x,y,'k');