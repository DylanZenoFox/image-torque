ima = imread('C:/Data/matlab/torque/codeTorque1/objs-actions/2011_07_09[19_42_09].oni.png');
ima1 = imresize(ima,0.5);
ima2 = rgb2gray(ima1);
ima_corner3= cornermetric(ima2, 'Sensitivityfactor',0.1);
f = find(ima_corner3(:,:)<-0.004);
BW = ima_corner3;
BW(f) = 1;
figure(1);
imagesc(BW);
[H,T,R] = hough(BW);
figure(2);
imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
% Find lines and plot them
lines = houghlines(BW,T,R,P,'MinLength',7);
figure(3), imshow(ima2), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');