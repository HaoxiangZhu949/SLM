% Parameters:
pixelSize = 5.4e-6; %m
sizeXY = [1000 1000]; % [1920 1080] for fullscreen DMD
dmdScreenNumber = 1;

LGell = 5;
LGp = 5;
w0 = 5e-4; %m

gratingAngle = 45; % this determines the angle of diffractions
gratingPeriod = 100e-6; %m

% -------------------------------------------------------------------------

% Create a meshgrid to work off:
x = pixelSize .* (-sizeXY(1)/2:(sizeXY(1)/2-1)); 
y = pixelSize .* (-sizeXY(2)/2:(sizeXY(2)/2-1)); 
[X,Y] = meshgrid(x,y);
[phi, r] = cart2pol(X,Y);

% Generate an LG beam: ----------------------------------------------------
RhoSquareOverWSquare = r.^2 ./ w0.^2; 

La = Laguerre(LGp, abs(LGell), 2*RhoSquareOverWSquare);
Clg = sqrt((2*gamma(LGp+1)) ./ (pi * gamma(abs(LGell)+LGp+1)));
E = Clg .* (sqrt(2)*sqrt(RhoSquareOverWSquare)).^abs(LGell) .* exp(-RhoSquareOverWSquare) .* La .* exp(-1i*LGell*phi);

%imagesc(angle(E)); % Check the phase
%imagesc(abs(E).^2); % Check the intensity

% Add a grating: ----------------------------------------------------------
theta = pi/180 .* gratingAngle;
plane = sin(theta) .* X + cos(theta) .* Y;

phase = angle(E);
w = asin(abs(E)/max(max(abs(E))));
binaryGrating = 0.5 + 0.5*sign(cos((2*pi)*plane/gratingPeriod + phase) - cos(w)); 

% Display: ----------------------------------------------------------------

imshow(binaryGrating);
set(gca,'dataAspectRatio',[1 1 1]);
